nrepl=177;

#for p in 8 6 4 3 2 36 32 25 16 9 ; do
for p in 6 4 3  ; do
    q="" ;
    if [ $p -gt 8 ] ; then
	q="--qos=standby" ;
    fi ;
    #q="--qos=standby" ;
    thexp="1.00468"
    ( srun -N$p -n$((36*$p)) $q -ppdebug -t60 /p/lustre1/tomaso/lammps-quartz/lammps-git/src/lmp_mpi -in in.bench -var thexp $thexp -var nxy ${nrepl} -var nz 8 > runx${nrepl}.p$p & ) ;
    sleep 5 ;
done
