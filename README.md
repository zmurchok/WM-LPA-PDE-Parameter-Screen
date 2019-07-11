# WM/LPA/PDE Parameter Screen

Code for MODELING CELL SHAPE DIVERSITY ARISING FROM COMPLEX RHO GTPASE DYNAMICS

Cole Zmurchok, William R. Holmes

**Please note that the code provided is not very well documented. It's currently set up to run on ACCRE, the computer cluster at Vanderbilt. Please contact me with any questions, I'd be happy to discuss.**

[cole.zmurchok@vanderbilt.edu](cole.zmurchok@vanderbilt.edu)
or
[zmurchok.github.io](zmurchok.github.io)

## Prerequisites

* Matlab (I used version 2018b locally and 2018a on ACCRE).
* matcont (https://sourceforge.net/projects/matcont/).
* FEniCS (for 2D simulations https://fenicsproject.org/)

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
11. ParameterScreen_plots.m: makes plots used in the first row of Figure 5
19. tristable_stability.m: makes last row of plots used in Figure 5.
12. PDEscreen.slurm: run the PDE screen on the server
13. PDEscreen.m: solves the PDEs for each block of 50000 parameters.
14. The PDE screen requires the following supporting files: solvethepdes.m, solvethepdes_noise.m, and data_counted.mat (so the WM and LPA screens need to happen first!)
15. rebuildPDEScreen.m: takes PDE screen output files and complies the data into one file: **data_PDEscreen.mat**.
16. PDEScreen_counts.m: post-processes the PDE screen data, saves data as **data_PDE_screen_counted.mat**
17. PDEscreen_table.m: provides numbers for Table 1
18. PDEscreen_plots.m: makes plots used in the middle row of Figure 5.

### Supporting Files:

#### Figures:

1. Fig2.m: generates Fig 2. Needs Fig2a_functions.m and Fig2b_functions.m
2. Fig3.m: generates panels (a) to (f) of Fig 3. Needs solver.m.
3. Fig4x.py: generates data for panel (x) of Fig 4. Requires FEniCS. The data in Fig4d was collected from simulations shown in Fig 4a-c. pub_plotter.py makes the panels for the figure, and plotter.py makes the SI Movies.
3. Figure 5 is produced in the screening above, with ParameterScreen_plots.m, PDEscreen_plots.m, and tristable_stability.m.
4. Figure 6 is produced with Fig6.m and Fig6a_driver.m, Fig6c_driver.m, and Fig6d_driver.m

#### Other Files:

4. solver.m: Needed for Fig 3.
5. millon_parameter_data.mat: datafile containing the results of the parameter screen!
6. seaborncolors.m: contains colors from the seaborn package from python.
7. lpa_jacobian.m: contains the Jacobian of the LPA system, evaluated symbolically
8. global_odes.m: well-mixed ODEs
9. local_odes.m: LPA ODEs
10. ParameterScreen.m: main file for the WM and LPA parameter screen
11. FindSteadyStates.m: file that finds the steady-states of the WM systems
12. is_polarized.m: checks if a PDE solution is polarized
