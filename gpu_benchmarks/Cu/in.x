## Reads input configuration, computes forces, and
## writes out positions, velocities, and forces

## You can run it like:
##     ~/lammps/lammps-29Oct20/src/lmp_mpi -in in.x -var nxy 8 -var nz 8

units		metal
atom_style	atomic

# This box definition doesn't matter. It will be overwritten when reading
# the input coordinates
  variable thexp equal 1
  lattice		fcc $(3.6150*v_thexp) # Cu lattice constant (in A)

  # Dimension of cell. for a larger quasi 2D system, maybe choose 0 100  0 100  0 10
  region		box block 0 ${nxy} 0 ${nxy} 0 ${nz}

  create_box	1 box

# read input configuration
read_dump cfgs/dump.cu-crystal-${nxy}x${nxy}x${nz}.20000.gz 20000 x y z vx vy vz box yes add yes
mass		1 63.550 # Cu mass on amu

displace_atoms all move 0.25 0.25 0.25
change_box all boundary s s s


# LAMMPS eam/alloy style, reading Cu_u6 converted to eam/alloy format
#pair_style	eam/alloy
#pair_coeff	* * ../../util/Cu.out.eam.alloy Cu

# LAMMPS eam style, same format as CoMD -- reading Cu_u6 potential
#pair_style	eam
#pair_coeff	* * Cu_u6.eam

# LAMMPS eam style, same format as CoMD -- reading Cu_u6 converted to eam/alloy and back
pair_style	eam
pair_coeff	* * ../../util/Cu.out.eam

neighbor	0.5 bin
neigh_modify	every 1 delay 0 check yes

fix		1 all nve

timestep 0.002

# COmpute forces, and then dump positions, velocities, and forces
run 0
write_dump all custom dump.x id type x y z vx vy vz fx fy fz  modify sort id

