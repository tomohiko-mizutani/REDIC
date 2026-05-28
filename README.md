# REDIC: Data-Reduced Self-Dictionary Methods for Endmember Extraction

This repository contains MATLAB code for the REDIC methods introduced in the following paper:

Hyperspectral Image Data Reduction for Endmember Extraction, arXiv:2512.10506.
[https://arxiv.org/abs/2512.10506](https://arxiv.org/abs/2512.10506)

## Requirements

You need to install CPLEX.
This code has been tested with CPLEX version 22.1.2.


## Build (MEX)

This code relies on the [EEHT code](https://github.com/tomohiko-mizutani/EEHT),
which requires compiling the MEX file `cplexlp_mex.c` located in `./eehtlib/mexfunc/`.

Makefiles are provided for Linux and macOS: `makefile.linux` and `makefile.mac`, respectively.
These makefiles assume that CPLEX version 22.1.2 is installed and that MATLAB R2024b is used.
You may need to modify them depending on your environment.

### macOS

Move to the directory and run the following command in the terminal:

```sh
make -f makefile.mac all
```

### Linux

Move to the directory and run the following command in the terminal:

```sh
make -f makefile.linux all
```

## Dataset

Due to file size limitations on GitHub, this repository does not include the datasets used by the code.
To run the code, please visit the following [Dropbox link](https://www.dropbox.com/scl/fi/h1hnkgrx9triusj3bmyi1/data.zip?rlkey=aj9r3plpnyzb3p7ood8yjj1wt&st=u9a1l3k0&dl=0) and download `data.zip`.

Extract `data.zip` to create the `data` directory.
Place the `data` directory at the same level as the `eehtlib`, `rediclib` and `scripts` directories.


## Quick Start

The scripts `runDrs.m` and `runRedic.m`, located in the `./scripts/` directory, run DRS (Algorithm 2) and REDIC (Algorithm 3) on hyperspectral image (HSI) datasets, including Jasper Ridge, Samson, and Urban.

Before running these scripts, you need to add the required directories to the MATLAB path.
Start MATLAB, navigate to the `./scripts/` directory, and run the following command:

```matlab
setup
```

### Running DRS

In the script `runDrs.m`, the variable `inData` specifies the input dataset.
Set `inData` to one of the following values: `'jasper'`, `'samson'`, or `'urban'`.
The script displays plots of the following quantities:

- The number of elements in the output set $\mathcal{K}$
- MRSA distance
- Reconstruction error
- Elapsed time

For details on the MRSA distance and reconstruction error,
refer to Section 5.2 of the arXiv paper.

#### Setting Parameter Values

You can specify the DRS parameters by setting the fields of the structure variable `opts` in the script, for example, `opts.numPartitions = 10`.
The details of these parameters are described in [Parameters in DRS](#parameters-in-drs).

#### Example Command

Below is an example command for running DRS on the Jasper Ridge dataset:

```matlab
runDrs
```

### Running REDIC

The variable `inData` in the script `runRedic.m` specifies the input dataset.
Set `inData` to one of the following values: `'jasper'`, `'samson'`, or `'urban'`.
The script displays plots of the following quantities:

- MRSA values for each endmember signatures and their mean
- Elapsed time

#### Setting Parameter Values

You can specify the REDIC parameters by setting the fields of the structure variable `redicOpts` in the script, for example, `redicOpts.numEehtRuns = 5` and `redicOpts.augSetSize = 250`.
The details of these parameters are described in [Parameters in REDIC](#parameters-in-redic).

You can also specify the EEHT parameters using the structure variable `eehtOpts`.
The details of these parameters are described in the [EEHT repository](https://github.com/tomohiko-mizutani/EEHT).

#### Example Command

Below is an example command for running REDIC on the Jasper Ridge dataset:

```matlab
runRedic
```

## Parameters in DRS

The DRS parameters are specified using the structure variable `opts`, which contains the following fields:

- `opts.numPartitions`:
Specifies the number of partitions $p$ of the columns of the input matrix. The default value is `30`.

- `opts.seed_kmeans`:
Specifies the random seed used for the $k$-means method. The default value is `37`.

- `opts.epsilon`:
Specifies the tolerance parameter $\epsilon_{\mathrm{feas}}$,
which is used to check whether the $i$ th column of the input data is contained
in the conical hull of the remaining columns by solving a nonnegative least-squares problem.
See Section 3.2 for details. The default value is `1.0e-8`.

## Parameters in REDIC

The REDIC parameters are specified using the structure variable `redicOpts`, which contains the following fields:

- `redicOpts.numPartitions`:
Specifies the number of partitions $p$ of the columns of the input matrix. The default value is `30`.

- `redicOpts.numEehtRuns`:
Specifies the number of runs of the LP-based method (i.e., the EEHT-C method), denoted by $\tau$.
The default value is `1`.

- `redicOpts.augSetSize`:
Specifies the number of additional elements $\lambda$. The default value is `0`.

- `redicOpts.seed_kmeans`:
Specifies the random seed used for the $k$-means method. The default value is `37`.

- `redicOpts.seed_addPts`:
Specifies the random seed used for randomly selecting the $\lambda$ additional elements.
The default value is `9848034`.

- `redicOpts.epsilon`:
Specifies the tolerance parameter $\epsilon_{\mathrm{feas}}$, which is used to check whether the $i$ th column of the input data is contained in the conical hull of the remaining columns by solving a nonnegative least-squares problem.
See Section 3.2 for details. The default value is `1.0e-8`.

- `redicOpts.displayFlag`:
Set to `1` to enable output display, or `0` to disable it. The default value is `0`.

## Reproducing the Experiments

You can reproduce the experiments presented in the arXiv paper using the MATLAB scripts in the `./scripts/` directory.
Before running the scripts, move to the directory and run the following command:

```matlab
setup
```

### 1. DRS Performance Evaluation Experiments

Section 5.2 presents performance evaluation experiments of DRS using Datasets 1–3, which are generated from the Jasper Ridge, Samson, and Urban datasets, respectively.

These experiments can be reproduced using the script `runDrsExp.m`.
The output files generated by the script are saved in the `./results/` directory.
The experimental results can be plotted using the following scripts:

| Script | Description |
|---|---|
| `runPlotDrsDistExpResults.m` | Plots the distance between the reference endmember matrix $W$ and $A(\mathcal{K} \cup \mathcal{K}_{\mathrm{add}})$ for the DRS output $\mathcal{K}$. Set `inData` to one of the following values: `dataset1`, `dataset2`, `dataset3_part1`, or `dataset3_part2`.
| `runPlotDrsSetSizeExpResults.m` | Plots the number of elements in $\mathcal{K}$ obtained by DRS. Set `inData` to one of the following values: `dataset1`, `dataset2`, or `dataset3`. |
| `runPlotDrsTimeExpResults.m` | Plots the elapsed time of DRS. Set `inData` to one of the following values: `dataset1`, `dataset2`, or `dataset3`. |


#### Example Commands

Run the experiments:

```matlab
runDrsExp
```

Plot the results for Dataset 1:

```matlab
runPlotDrsExpResults
```

### 2. REDIC Performance Evaluation Experiments

Section 5.3 presents the performance evaluation experiments of REDIC using the Jasper Ridge, Samson, and Urban datasets.

These experiments can be reproduced using the script `runRedicExp.m`.
The output files generated by the script are saved in the `./results/` directory.
You can plot the results for these datasets using `runPlotRedicExpResults.m`.

#### Example Commands

Run the experiments for the Jasper Ridge, Samson, and Urban datasets:

```matlab
runRedicExp
```

Plot the results:

```matlab
runPlotRedicExpResults
```

### 3. 2D Data Visualization of the Samson Dataset

Section 1 presents figures showing a 2D visualization of the Samson dataset
before and after applying DRS.
These figures can be reproduced using the script `runPlotSamsonData2D.m`.

The script displays plots of the following quantities:

- The number of pixels in the Samson dataset
- The number of elements in the set $\mathcal{K}$ output by DRS

#### Example Command

Run the following command:

```matlab
runPlotSamsonData2D
```

### 4. Reference Abundance Maps

You can examine the reference abundance maps for the Jasper Ridge, Samson, and Urban datasets.
The script `runComputeRefAbundanceMaps.m` computes the reference abundance maps based on the reference endmember signatures, which are generated following the procedure described in Section 5.3.

The output files generated by the script are saved in the `./results/` directory.
You can plot the results for these datasets using `runPlotRefAbundanceMaps.m` by setting `inData` to one of the following values: `'jasper'`, `'samson'`, or `'urban'`.

#### Example Commands

Run the following command:

```matlab
runComputeRefAbundanceMaps
```

Plot the results for the Jasper Ridge dataset:

```matlab
runPlotRefAbundanceMaps
```

---
Contact: Tomohiko Mizutani [(mizutani.t@shizuoka.ac.jp)](mailto:mizutani.t@shizuoka.ac.jp)
