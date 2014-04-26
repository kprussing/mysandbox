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
    integer :: I
    character(len=32) :: arg
    call get_command_argument(1, arg)
    if (len_trim(arg) == 0) then
        STOP "I need an argument!"
    end if
    read(arg, "(I32)") I

    !call hello()
    !call compute_pi(100000)
    !call exercise_4(100000)
    call mc_pi(I)
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

!subroutine compute_pi(nsteps)
    !use, intrinsic :: iso_fortran_env, only: output_unit
    !! Compute pi by evaluating the integral $\int_0^1 4.0/(1+x^2) dx$.
    !integer, intent(in) :: nsteps
    !integer :: I, N, rem, start, tid, nthreads
    !integer :: omp_get_thread_num, omp_get_num_threads
    !real    :: x, dx
    !real    :: pi(8)

    !pi = 0.0
    !dx = 1.0 /real(nsteps)

    !!$OMP PARALLEL NUM_THREADS(8) SHARED(dx, nsteps, pi) &
    !!$OMP PRIVATE(I, N, nthreads, rem, start, tid, x) 

    !! Determine how many values to compute.
    !tid      = omp_get_thread_num()
    !nthreads = omp_get_num_threads()

    !N   = nsteps /nthreads
    !rem = mod(nsteps, nthreads)
    !start = N *tid +1
    !if (tid < rem) then
        !N = N +1
        !start = start +tid
    !else
        !start = start +rem
    !end if
    !write(output_unit, "(A6,I2,1X,A8,I7,1X,A4,I7,1X,A2,I7)") &
        !"Thread", tid, "computes", N, "from", start, "to", start +N -1

    !do I = start, start +N -1
        !x = (real(I) -0.5) *dx
        !!$OMP ATOMIC
        !pi(tid+1) = pi(tid+1) +4.0 /(1.0 +x*x)
    !end do
    !!$OMP END PARALLEL

    !pi = pi *dx

    !write(output_unit, *) "Computed pi as ", sum(pi)

!end subroutine compute_pi

subroutine exercise_4(nsteps)
    use, intrinsic :: iso_fortran_env, only: output_unit
    ! Compute pi by evaluating the integral $\int_0^1 4.0/(1+x^2) dx$.
    integer, intent(in) :: nsteps
    integer :: I
    real    :: x, dx, pi

    pi = 0.0
    dx = 1.0 /real(nsteps)

    ! Use specify everything in order to make it work correctly.  The
    ! value is different based on what is specified.  By omitting the
    ! private statement, things get wrong.
    !$OMP PARALLEL DO REDUCTION(+:pi) PRIVATE(I, x) SHARED(nsteps, dx)
    do I = 1, nsteps
        x = (real(I) -0.5) *dx
        pi = pi +4.0 /(1.0 +x*x)
    end do

    pi = pi *dx

    write(output_unit, *) "Computed pi as ", pi

end subroutine exercise_4

subroutine mc_pi(ntrys)
    use, intrinsic :: iso_fortran_env, only: output_unit
    ! Compute pi using a Monte-Carlos approach.
    integer, intent(in) :: ntrys
    integer :: I, cnt
    real    :: x, y, pi

    cnt = 0
    !$OMP PARALLEL DO REDUCTION(+:cnt) PRIVATE(x,y,I) SHARED(ntrys)
    do I = 1,ntrys
        call random_number(x)
        call random_number(y)
        if (x*x +y*y <= 1.0) then
            cnt = cnt +1
        end if
    end do

    pi = real(cnt) /real(ntrys) *4.0
    write(output_unit, *) "Computed pi as ", pi

end subroutine mc_pi

end program openmpplay

