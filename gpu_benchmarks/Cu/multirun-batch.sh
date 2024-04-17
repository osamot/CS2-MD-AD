nrepl=177;

for p in 64 100 128 144 256 400 512 1024 ; do
    thexp="1.00468"
    ( srun -N$p -n$((36*$p)) -t10 --qos=standby /p/lustre1/tomaso/lammps-quartz/lammps-git/src/lmp_mpi -in in.bench -var thexp $thexp -var nxy ${nrepl} -var nz 8 -log log.runx${nrepl}.p$p-standby > runx${nrepl}.p$p-standby & ) ;
done
