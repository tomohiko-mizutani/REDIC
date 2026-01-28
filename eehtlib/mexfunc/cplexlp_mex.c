#include "mex.h"
#include "matrix.h"
#include <ilcplex/cplex.h>
#include <string.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 6)
        mexErrMsgTxt("Usage: [x, fval, lambda, exitflag] = cplexlp_mex(c, A_sparse, b, lb, ub, method)");

    if (!mxIsSparse(prhs[1]))
        mexErrMsgTxt("A must be a sparse matrix.");

    double *c = mxGetPr(prhs[0]);
    double *b = mxGetPr(prhs[2]);
    double *lb = mxIsEmpty(prhs[3]) ? NULL : mxGetPr(prhs[3]);
    double *ub = mxIsEmpty(prhs[4]) ? NULL : mxGetPr(prhs[4]);

    mwSize n = mxGetM(prhs[0]);           // Numer of variables
    mwSize m = mxGetM(prhs[2]);           // Number of constraints
    mwSize num_columns = mxGetN(prhs[1]); // Number of columns in A

    if (n != num_columns)
        mexErrMsgTxt("Length of c must match number of columns in A.");

    int method = (int)(mxGetScalar(prhs[5]));
    int cpx_method;
    switch (method)
    {
    case 0:
        cpx_method = CPX_ALG_AUTOMATIC;
        break;
    case 1:
        cpx_method = CPX_ALG_PRIMAL;
        break;
    case 2:
        cpx_method = CPX_ALG_DUAL;
        break;
    case 3:
        cpx_method = CPX_ALG_NET;
        break;
    case 4:
        cpx_method = CPX_ALG_BARRIER;
        break;
    case 5:
        cpx_method = CPX_ALG_SIFTING;
        break;
    case 6:
        cpx_method = CPX_ALG_CONCURRENT;
        break;
    default:
        mexErrMsgTxt("Invalid method (0–6).");
    }

    mwIndex *jc = mxGetJc(prhs[1]); // Column pointer
    mwIndex *ir = mxGetIr(prhs[1]); // Row indices
    double *pr = mxGetPr(prhs[1]);  // Values


    int *matcnt = (int *)mxCalloc(n, sizeof(int));
    for (mwIndex j = 0; j < n; ++j)
        matcnt[j] = (int)(jc[j + 1] - jc[j]);


    int *matbeg = (int *)mxCalloc(n, sizeof(int));
    for (mwIndex j = 0; j < n; ++j)
        matbeg[j] = (int)(jc[j]);


    int *matind = (int *)mxCalloc(jc[n], sizeof(int));
    for (mwIndex i = 0; i < jc[n]; ++i)
        matind[i] = (int)(ir[i]);


    char *sense = (char *)mxCalloc(m, sizeof(char));
    for (mwIndex i = 0; i < m; ++i)
        sense[i] = 'L';


    int status;
    CPXENVptr env = CPXopenCPLEX(&status);
    if (env == NULL)
        mexErrMsgTxt("Failed to open CPLEX environment.");

    CPXLPptr lp = CPXcreateprob(env, &status, "LP_problem");
    if (lp == NULL)
    {
        CPXcloseCPLEX(&env);
        mexErrMsgTxt("Failed to create CPLEX problem.");
    }

    // Set solver parameters
    CPXsetintparam(env, CPX_PARAM_LPMETHOD, cpx_method);

    // Build LP model
    status = CPXcopylp(env, lp, (int)n, (int)m, CPX_MAX, c, b, sense,
                       matbeg, matcnt, matind, pr, lb, ub, NULL);

    // Free memory
    mxFree(matbeg);
    mxFree(matcnt);
    mxFree(matind);
    mxFree(sense);

    if (status)
    {
        char errmsg[1024];
        CPXgeterrorstring(env, status, errmsg);
        mexPrintf("CPXcopylp failed: %s\n", errmsg);
        CPXfreeprob(env, &lp);
        CPXcloseCPLEX(&env);
        mexErrMsgTxt("CPXcopylp failed.");
    }

    // Solve LP
    status = CPXlpopt(env, lp);
    if (status)
    {
        int solstat = CPXgetstat(env, lp);
        mexPrintf("CPLEX solve error: status=%d, solstat=%d\n", status, solstat);
        CPXfreeprob(env, &lp);
        CPXcloseCPLEX(&env);
        mexErrMsgTxt("CPLEX failed to solve the problem.");
    }

    // Get solution
    double *x = (double *)mxCalloc(n, sizeof(double));
    double *lambda_ineq = (double *)mxCalloc(m, sizeof(double));
    double *rc = (double *)mxCalloc(n, sizeof(double));
    double fval = 0.0;

    CPXgetx(env, lp, x, 0, n - 1);
    CPXgetobjval(env, lp, &fval);
    CPXgetpi(env, lp, lambda_ineq, 0, m - 1);
    CPXgetdj(env, lp, rc, 0, n - 1);

    // Output: x
    plhs[0] = mxCreateDoubleMatrix(n, 1, mxREAL);
    memcpy(mxGetPr(plhs[0]), x, n * sizeof(double));

    // Output: fval
    if (nlhs > 1)
        plhs[1] = mxCreateDoubleScalar(fval);

    // Output: lambda
    if (nlhs > 2)
    {
        mxArray *lambda_struct = mxCreateStructMatrix(1, 1, 0, NULL);

        mxAddField(lambda_struct, "ineqlin");
        mxArray *ineqlin = mxCreateDoubleMatrix(m, 1, mxREAL);
        memcpy(mxGetPr(ineqlin), lambda_ineq, m * sizeof(double));
        mxSetField(lambda_struct, 0, "ineqlin", ineqlin);

        mxAddField(lambda_struct, "lower");
        mxArray *lower = mxCreateDoubleMatrix(n, 1, mxREAL);
        double *lower_ptr = mxGetPr(lower);

        for (mwIndex i = 0; i < n; ++i)
            if (lb && x[i] <= lb[i] + 1e-8)
            {
                lower_ptr[i] = -rc[i];
            }
            else
            {
                lower_ptr[i] = 0.0;
            }
        mxSetField(lambda_struct, 0, "lower", lower);

        mxAddField(lambda_struct, "upper");
        mxArray *upper = mxCreateDoubleMatrix(n, 1, mxREAL);
        double *upper_ptr = mxGetPr(upper);

        for (mwIndex i = 0; i < n; ++i)
            if (ub && x[i] >= ub[i] - 1e-8)
            {
                upper_ptr[i] = rc[i];
            }
            else
            {
                upper_ptr[i] = 0.0;
            }
        mxSetField(lambda_struct, 0, "upper", upper);

        plhs[2] = lambda_struct;
    }

    // Output: exitflag
    if (nlhs > 3)
    {
        int solstat = CPXgetstat(env, lp);
        int exitflag = 0;

        switch (solstat)
        {
        case CPX_STAT_OPTIMAL:
            exitflag = 1; // Solved to optimality
            break;
        case CPX_STAT_INFEASIBLE:
            exitflag = -2; // Infeasible
            break;
        case CPX_STAT_UNBOUNDED:
            exitflag = -3; // Unbounded
            break;
        default:
            exitflag = 0; // Other status codes
        }
        plhs[3] = mxCreateDoubleScalar((double)exitflag);
    }


    mxFree(x);
    mxFree(lambda_ineq);
    mxFree(rc);
    CPXfreeprob(env, &lp);
    CPXcloseCPLEX(&env);
}