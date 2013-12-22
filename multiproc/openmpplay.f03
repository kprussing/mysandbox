!--------1---------2---------3---------4---------5---------6---------7--
! A program to let me work along with the Lawrence Livermore National
! Lab tutorial on OpenMP.  I am also studying a tutorial from Tim
! Mattson and Larry Meadows from it appears SC08.  To find it look for
! "openmp-hands-on-SC08.pdf" on the interwebz.
!
! Keith Prussing 2013-12-21
!
!--------1---------2---------3---------4---------5---------6---------7--

program openmpplay
    implicit none
    call compute_pi(100000)
contains

!subroutine hello()
    !use, intrinsic :: iso_fortran_env, only: output_unit
    !integer :: nthread, tid
    !integer :: OMP_GET_NUM_THREADS, OMP_GET_THREAD_NUM
    !character(len=7) :: greeting
    !!
    !! Create the team
    !!$OMP PARALLEL NUM_THREADS(7) PRIVATE(TID)
    !!
    !! Write the thread id
    !tid = OMP_GET_THREAD_NUM()
    !greeting = "Hello"
    !write(output_unit, *) greeting, "world from from thread ", tid
    !!
    !! Only the master does this
    !if (tid == 0) then
        !nthread = OMP_GET_NUM_THREADS()
        !write(output_unit, *) "  Total number of threads is ", nthread
    !end if
    !!
    !!$OMP END PARALLEL
    !!
!end subroutine hello

subroutine compute_pi(nsteps)
    use, intrinsic :: iso_fortran_env, only: output_unit
    ! Compute pi by evaluating the integral $\int_0^1 4.0/(1+x^2) dx$.
    integer, intent(in) :: nsteps
    integer :: I, N, rem, start, tid, nthreads
    integer :: omp_get_thread_num, omp_get_num_threads
    real    :: x, pi, dx

    pi = 0.0
    dx = 1.0 /real(nsteps)

    ! Serial
    !start = 1
    !N     = nsteps

    !$OMP PARALLEL NUM_THREADS(8) SHARED(dx, nsteps, pi) &
    !$OMP PRIVATE(I, N, nthreads, rem, start, tid, x) 

    ! Determine how many values to compute.
    tid      = omp_get_thread_num()
    nthreads = omp_get_num_threads()

    ! Get the base size of the bock
    N   = nsteps /nthreads
    rem = mod(nsteps, nthreads)
    start = N *tid +1
    if (tid < rem) then
        N = N +1
        start = start +tid
    else
        start = start +rem
    end if
    write(output_unit, "(A6,I2,1X,A8,I7,1X,A4,I7,1X,A2,I7)") &
        "Thread", tid, "computes", N, "from", start, "to", start +N -1

    do I = start, start +N -1
        x = (real(I) -0.5) *dx
        pi = pi +4.0 /(1.0 +x*x)
    end do
    !$OMP END PARALLEL

    pi = pi *dx

    write(output_unit, *) "Computed pi as ", pi

end subroutine compute_pi

end program openmpplay

