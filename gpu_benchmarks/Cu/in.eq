# Single crystal simulation of W (tungsten) at 2000 K with periodic bonday conditions

#processors * * 1 grid twolevel 36 6 6 1

units		metal
atom_style	atomic


lattice		fcc $(3.6150*v_thexp) # Cu lattice constant (in A)

# Dimension of cell. for a larger quasi 2D system, maybe choose 0 100  0 100  0 10
region		box block 0 ${nxy} 0 ${nxy} 0 ${nz}

create_box	1 box
#read_dump cfgs/dump.cu-crystal-${nxy}x${nxy}x${nz}.20000.gz 20000 x y z vx vy vz box yes add yes
create_atoms	1 box
mass		1 63.550 # Cu mass on amu

## Setting initial velocities to 4000 K. Equipartitioning will quickly reduce this to ~2000 K.
velocity	all create 580.0 87287 loop geom

#pair_style	eam/alloy
#pair_coeff	* * Cu_u6.eam Cu
pair_style	eam
pair_coeff	* * Cu_u6.eam

neighbor	0.5 bin
neigh_modify	every 1 delay 0 check yes


fix		1 all nve
#fix		  1 all nvt temp 6000 8000 0.1

# Save configutation every 400 steps.
dump dumper all custom 10000 dump.cu-crystal-${nxy}x${nxy}x${nz}.* id type x y z vx vy vz fx fy fz

compute msd all msd com yes


fix avgs all ave/time 1 1000 1000 c_thermo_press c_thermo_temp
#fix pavg all ave/time 1 100 100 c_thermo_press

thermo_style custom step f_avgs[2] pe etotal f_avgs[1] c_msd[1]

timestep 0.002  ## 2 fs timestep. For production maybe 5 or 10 fs can be used.
#restart 1000 bla.rst.*
thermo		1000
run		100000
