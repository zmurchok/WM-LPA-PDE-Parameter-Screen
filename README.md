# WM/LPA/PDE Parameter Screen

Code for MODELING CELL SHAPE DIVERSITY ARISING FROM COMPLEX RHO GTPASE DYNAMICS

Cole Zmurchok, William R. Holmes

**Please note that the code provided isn't the clearest, nor written in the best way. It's currently set up to run on ACCRE, the computer cluster at Vanderbilt. Please contact me with any questions, I'd be happy to discuss.**

[cole.zmurchok@vanderbilt.edu](cole.zmurchok@vanderbilt.edu)
or
[zmurchok.github.io](zmurchok.github.io)

## Prerequisites

* Matlab (I used version 2018b locally and 2018a on ACCRE).
* matcont (https://sourceforge.net/projects/matcont/).

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [ACCRE at Vanderbilt University](https://www.vanderbilt.edu/accre/)

## Files and what they do!


### Parameter Screen

I split the 10^6 parameter sets up into 20 blocks of 50000 for parallel computing. This is the workflow:

1. X.mat: Latin Hypercube sample of parameter space
2. newX.m: used to make X1-X20.mat from X.mat. Generated from LatinHypercubeSample.m
3. X1-X20.mat: LHS of parameter space. X1-20 used for parallelized computation.
4. main1-20.m: WM/LPA parameter sweep file. main1-20.m runs the parameter screen on block 1-20.
5. Parameterscreen.slurm: the scheduler file that calls 20 jobs on ACCRE to each run one of main1-20.m
6. main1-20.mat: output from each one of the 20 main1-20.m jobs
7. rebuildX.mat: take all output and build the data set. output of WM and LPA screens saved as **data.mat**
8. The WM and LPA screens need the following supporting files: global_odes.m, local_odes.m, lpa_jacobian.m, ParameterScreen.m, FindSteadySates.m
9. ParameterScreen_counts.m: post-processes the WM and LPA screen data, saves data as **data_counted.mat**
9. checkfortwos.m: checks for problems with the LPA screen... 2's are bad! They indicate that the LPA perturbations ended up at another HSS instead of a new local branch. It turns out that I didn't find any twos! See ParameterScreen.m for more detail. These troublesome points would have to be dealt with.
10. LPAscreen_table.m: provides numbers for Table 1
11. ParameterScreen_plots.m: makes plots used in Figure 3
19. tristable_stability.m: makes last row of plots used in Figure 3.
12. PDEscreen.slurm: run the PDE screen on the server
13. PDEscreen.m: solves the PDEs for each block of 50000 parameters.
14. The PDE screen requires the following supporting files: solvethepdes.m, solvethepdes_noise.m, and data_counted.mat (so the WM and LPA screens need to happen first!)
15. rebuildPDEScreen.m: takes PDE screen output files and complies the data into one file: **data_PDEscreen.mat**.
16. PDEScreen_counts.m: post-processes the PDE screend ata, saves data as **data_PDE_screen_counted.mat**
17. PDEscreen_table.m: provides numbers for Table 1
18. PDEscreen_plots.m: makes plots used in Figure 3.

### Supporting Files:

1. Fig2.m: generates Fig 2.
2. Fig3atod.m: generates panels (a) to (d) of Fig 3.
3. Fig3etoh.m: generates panels (e) to (h) of Fig 3.
4. solvethepdes_for_figs.m: required for Fig3etoh
5. testrun_millon.mat: first pass at parameter screen (some data in here used for Fig3)
6. seaborncolors.m: contains colors from the seaborn package for python.
7. lpa_jacobian.m: contains the Jacobian of the LPA system, evaluated symbolically
8. global_odes.m: well-mixed ODEs
9. local_odes.m: LPA ODEs
10. ParameterScreen.m: main file for the WM and LPA parameter screen
11. FindSteadyStates.m: file that finds the steady-states of the WM systems
12. is_polarized.m: checks if a PDE solution is polarized
13. checkfortwos.m: checks to ensure that each steady-state found in the LPA ODEs is different from the
14. PDEtest.m: runs some PDE sims of interest for testing...uses solvethepdes_time.m and solvethepdes_time2.m. Requires completed PDE screen (data_PDE_screen_counted.mat).
