!--------1---------2---------3---------4---------5---------6---------7--
! Determine the path separator for the system, the executable command,
! and the executable directory.  I have no idea why I wanted to know
! this information.  It was probably to locate a file that had
! additional resources for whatever program I was working on.  I'm
! willing to bet that this is simply an novel solution to what is really
! a dumb question
!
! Keith Prussing 2013-12-21
!
!--------1---------2---------3---------4---------5---------6---------7--

program pathstuff
    implicit none
    character(len=80) :: foo, bar
    character(len=1)  :: sep
    integer           :: it, length, len1
    !
    call get_command_argument(0, foo, len1)
    call get_environment_variable("PATH", bar, length=length)
    do it = 1,length
        if (bar(it:it) == ":") then
            sep = bar(it+1:it+1)
            exit
        end if
    end do
    do it = len1, 1, -1
        if (foo(it:it) == sep) then
            bar = trim(foo(1:it))
            exit
        end if
    end do
    !
    print *, "Executable command   : ", trim(foo)
    print *, "Path separator       : ", sep
    print *, "Executable directory : ", trim(bar)
    !
end program pathstuff

