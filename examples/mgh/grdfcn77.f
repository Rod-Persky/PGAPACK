      subroutine grdfcn(n,x,g,nprob)
      integer n,nprob
      double precision x(n),g(n)
c     **********
c
c     subroutine grdfcn
c
c     This subroutine defines the gradient vectors of eighteen
c     nonlinear unconstrained minimization problems. The problem
c     dimensions are as described in the prologue comments of objfcn.
c
c     The subroutine statement is
c
c       subroutine grdfcn(n,x,g,nprob)
c
c     where
c
c       n is a positive integer input variable.
c
c       x is an input array of length n.
c
c       g is an output array of length n which contains the components
c         of the gradient vector of the nprob objective function
c         evaluated at x.
c
c       nprob is a positive integer input variable which defines the
c         number of the problem. nprob must not exceed 18.
c
c     Subprograms called
c
c       FORTRAN-supplied ... abs,atan,cos,dble,exp,log,sign,sin,sqrt
c
c     Argonne National Laboratory. MINPACK Project. march 1980.
c     Burton S. Garbow, Kenneth E. Hillstrom, Jorge J. More
c
c     **********
      integer i,iev,j
      double precision ap,arg,c2pdm6,cp0001,cp1,cp2,cp25,cp5,c1p5,
     *                 c2p25,c2p625,c3p5,c19p8,c20p2,c25,c29,c100,
     *                 c180,c200,c10000,c1pd6,d1,d2,eight,fifty,five,
     *                 four,one,r,s1,s2,s3,t,t1,t2,t3,ten,th,three,
     *                 tpi,twenty,two,zero
      double precision fvec(50),y(15)
      data zero,one,two,three,four,five,eight,ten,twenty,fifty
     *     /0.0d0,1.0d0,2.0d0,3.0d0,4.0d0,5.0d0,8.0d0,1.0d1,2.0d1,
     *      5.0d1/
      data c2pdm6,cp0001,cp1,cp2,cp25,cp5,c1p5,c2p25,c2p625,c3p5,
     *     c19p8,c20p2,c25,c29,c100,c180,c200,c10000,c1pd6
     *     /2.0d-6,1.0d-4,1.0d-1,2.0d-1,2.5d-1,5.0d-1,1.5d0,2.25d0,
     *      2.625d0,3.5d0,1.98d1,2.02d1,2.5d1,2.9d1,1.0d2,1.8d2,2.0d2,
     *      1.0d4,1.0d6/
      data ap /1.0d-5/
      data y(1),y(2),y(3),y(4),y(5),y(6),y(7),y(8),y(9),y(10),y(11),
     *     y(12),y(13),y(14),y(15)
     *     /9.0d-4,4.4d-3,1.75d-2,5.4d-2,1.295d-1,2.42d-1,3.521d-1,
     *      3.989d-1,3.521d-1,2.42d-1,1.295d-1,5.4d-2,1.75d-2,4.4d-3,
     *      9.0d-4/
c
c     Gradient routine selector.
c
      go to (10,20,50,70,80,100,130,190,220,260,270,290,310,350,370,
     *       390,400,410), nprob
c
c     Helical valley function.
c
   10 continue
      tpi = eight*atan(one)
      th = sign(cp25,x(2))
      if (x(1) .gt. zero) th = atan(x(2)/x(1))/tpi
      if (x(1) .lt. zero) th = atan(x(2)/x(1))/tpi + cp5
      arg = x(1)**2 + x(2)**2
      r = sqrt(arg)
      t = x(3) - ten*th
      s1 = ten*t/(tpi*arg)
      g(1) = c200*(x(1) - x(1)/r + x(2)*s1)
      g(2) = c200*(x(2) - x(2)/r - x(1)*s1)
      g(3) = two*(c100*t + x(3))
      return
c
c     Biggs exp6 function.
c
   20 continue
      do 30 j = 1, 6
         g(j) = zero
   30    continue
      do 40 i = 1, 13
         d1 = dble(i)/ten
         d2 = exp(-d1) - five*exp(-ten*d1) + three*exp(-four*d1)
         s1 = exp(-d1*x(1))
         s2 = exp(-d1*x(2))
         s3 = exp(-d1*x(5))
         t = x(3)*s1 - x(4)*s2 + x(6)*s3 - d2
         th = d1*t
         g(1) = g(1) - s1*th
         g(2) = g(2) + s2*th
         g(3) = g(3) + s1*t
         g(4) = g(4) - s2*t
         g(5) = g(5) - s3*th
         g(6) = g(6) + s3*t
   40    continue
      g(1) = two*x(3)*g(1)
      g(2) = two*x(4)*g(2)
      g(3) = two*g(3)
      g(4) = two*g(4)
      g(5) = two*x(6)*g(5)
      g(6) = two*g(6)
      return
c
c     Gaussian function.
c
   50 continue
      g(1) = zero
      g(2) = zero
      g(3) = zero
      do 60 i = 1, 15
         d1 = cp5*dble(i-1)
         d2 = c3p5 - d1 - x(3)
         arg = -cp5*x(2)*d2**2
         r = exp(arg)
         t = x(1)*r - y(i)
         s1 = r*t
         s2 = d2*s1
         g(1) = g(1) + s1
         g(2) = g(2) - d2*s2
         g(3) = g(3) + s2
   60    continue
      g(1) = two*g(1)
      g(2) = x(1)*g(2)
      g(3) = two*x(1)*x(2)*g(3)
      return
c
c     Powell badly scaled function.
c
   70 continue
      t1 = c10000*x(1)*x(2) - one
      s1 = exp(-x(1))
      s2 = exp(-x(2))
      t2 = s1 + s2 - one - cp0001
      g(1) = two*(c10000*x(2)*t1 - s1*t2)
      g(2) = two*(c10000*x(1)*t1 - s2*t2)
      return
c
c     Box 3-dimensional function.
c
   80 continue
      g(1) = zero
      g(2) = zero
      g(3) = zero
      do 90 i = 1, 10
         d1 = dble(i)
         d2 = d1/ten
         s1 = exp(-d2*x(1))
         s2 = exp(-d2*x(2))
         s3 = exp(-d2) - exp(-d1)
         t = s1 - s2 - s3*x(3)
         th = d2*t
         g(1) = g(1) - s1*th
         g(2) = g(2) + s2*th
         g(3) = g(3) - s3*t
   90    continue
      g(1) = two*g(1)
      g(2) = two*g(2)
      g(3) = two*g(3)
      return
c
c     Variably dimensioned function.
c
  100 continue
      t1 = zero
      do 110 j = 1, n
         t1 = t1 + dble(j)*(x(j) - one)
  110    continue
      t = t1*(one + two*t1**2)
      do 120 j = 1, n
         g(j) = two*(x(j) - one + dble(j)*t)
  120    continue
      return
c
c     Watson function.
c
  130 continue
      do 140 j = 1, n
         g(j) = zero
  140    continue
      do 180 i = 1, 29
         d1 = dble(i)/c29
         s1 = zero
         d2 = one
         do 150 j = 2, n
            s1 = s1 + dble(j-1)*d2*x(j)
            d2 = d1*d2
  150       continue
         s2 = zero
         d2 = one
         do 160 j = 1, n
            s2 = s2 + d2*x(j)
            d2 = d1*d2
  160       continue
         t = s1 - s2**2 - one
         s3 = two*d1*s2
         d2 = two/d1
         do 170 j = 1, n
            g(j) = g(j) + d2*(dble(j-1) - s3)*t
            d2 = d1*d2
  170       continue
  180    continue
      t1 = x(2) - x(1)**2 - one
      g(1) = g(1) + x(1)*(two - four*t1)
      g(2) = g(2) + two*t1
      return
c
c     Penalty function I.
c
  190 continue
      t1 = -cp25
      do 200 j = 1, n
         t1 = t1 + x(j)**2
  200    continue
      d1 = two*ap
      th = four*t1
      do 210 j = 1, n
         g(j) = d1*(x(j) - one) + x(j)*th
  210    continue
      return
c
c     Penalty function II.
c
  220 continue
      t1 = -one
      do 230 j = 1, n
         t1 = t1 + dble(n-j+1)*x(j)**2
  230    continue
      d1 = exp(cp1)
      d2 = one
      th = four*t1
      do 250 j = 1, n
         g(j) = dble(n-j+1)*x(j)*th
         s1 = exp(x(j)/ten)
         if (j .gt. 1) then
            s3 = s1 + s2 - d2*(d1 + one)
            g(j) = g(j) + ap*s1*(s3 + s1 - one/d1)/five
            g(j-1) = g(j-1) + ap*s2*s3/five
            end if
         s2 = s1
         d2 = d1*d2
  250    continue
      g(1) = g(1) + two*(x(1) - cp2)
      return
c
c     Brown badly scaled function.
c
  260 continue
      t1 = x(1) - c1pd6
      t2 = x(2) - c2pdm6
      t3 = x(1)*x(2) - two
      g(1) = two*(t1 + x(2)*t3)
      g(2) = two*(t2 + x(1)*t3)
      return
c
c     Brown and Dennis function.
c
  270 continue
      g(1) = zero
      g(2) = zero
      g(3) = zero
      g(4) = zero
      do 280 i = 1, 20
         d1 = dble(i)/five
         d2 = sin(d1)
         t1 = x(1) + d1*x(2) - exp(d1)
         t2 = x(3) + d2*x(4) - cos(d1)
         t = t1**2 + t2**2
         s1 = t1*t
         s2 = t2*t
         g(1) = g(1) + s1
         g(2) = g(2) + d1*s1
         g(3) = g(3) + s2
         g(4) = g(4) + d2*s2
  280    continue
      g(1) = four*g(1)
      g(2) = four*g(2)
      g(3) = four*g(3)
      g(4) = four*g(4)
      return
c
c     Gulf research and development function.
c
  290 continue
      g(1) = zero
      g(2) = zero
      g(3) = zero
      d1 = two/three
      do 300 i = 1, 99
         arg = dble(i)/c100
         r = (-fifty*log(arg))**d1 + c25 - x(2)
         t1 = abs(r)**x(3)/x(1)
         t2 = exp(-t1)
         t = t2 - arg
         s1 = t1*t2*t
         g(1) = g(1) + s1
         g(2) = g(2) + s1/r
         g(3) = g(3) - s1*log(abs(r))
  300    continue
      g(1) = two*g(1)/x(1)
      g(2) = two*x(3)*g(2)
      g(3) = two*g(3)
      return
c
c     Trigonometric function.
c
  310 continue
      s1 = zero
      do 320 j = 1, n
         g(j) = cos(x(j))
         s1 = s1 + g(j)
  320    continue
      s2 = zero
      do 330 j = 1, n
         th = sin(x(j))
         t = dble(n+j) - th - s1 - dble(j)*g(j)
         s2 = s2 + t
         g(j) = (dble(j)*th - g(j))*t
  330    continue
      do 340 j = 1, n
         g(j) = two*(g(j) + sin(x(j))*s2)
  340    continue
      return
c
c     Extended Rosenbrock function.
c
  350 continue
      do 360 j = 1, n, 2
         t1 = one - x(j)
         g(j+1) = c200*(x(j+1) - x(j)**2)
         g(j) = -two*(x(j)*g(j+1) + t1)
  360    continue
      return
c
c     Extended Powell function.
c
  370 continue
      do 380 j = 1, n, 4
         t = x(j) + ten*x(j+1)
         t1 = x(j+2) - x(j+3)
         s1 = five*t1
         t2 = x(j+1) - two*x(j+2)
         s2 = four*t2**3
         t3 = x(j) - x(j+3)
         s3 = twenty*t3**3
         g(j) = two*(t + s3)
         g(j+1) = twenty*t + s2
         g(j+2) = two*(s1 - s2)
         g(j+3) = -two*(s1 + s3)
  380    continue
      return
c
c     Beale function.
c
  390 continue
      s1 = one - x(2)
      t1 = c1p5 - x(1)*s1
      s2 = one - x(2)**2
      t2 = c2p25 - x(1)*s2
      s3 = one - x(2)**3
      t3 = c2p625 - x(1)*s3
      g(1) = -two*(s1*t1 + s2*t2 + s3*t3)
      g(2) = two*x(1)*(t1 + x(2)*(two*t2 + three*x(2)*t3))
      return
c
c     Wood function.
c
  400 continue
      s1 = x(2) - x(1)**2
      s2 = one - x(1)
      s3 = x(2) - one
      t1 = x(4) - x(3)**2
      t2 = one - x(3)
      t3 = x(4) - one
      g(1) = -two*(c200*x(1)*s1 + s2)
      g(2) = c200*s1 + c20p2*s3 + c19p8*t3
      g(3) = -two*(c180*x(3)*t1 + t2)
      g(4) = c180*t1 + c20p2*t3 + c19p8*s3
      return
c
c     Chebyquad function.
c
  410 continue
      do 420 i = 1, n
         fvec(i) = zero
  420    continue
      do 440 j = 1, n
         t1 = one
         t2 = two*x(j) - one
         t = two*t2
         do 430 i = 1, n
            fvec(i) = fvec(i) + t2
            th = t*t2 - t1
            t1 = t2
            t2 = th
  430       continue
  440    continue
      d1 = one/dble(n)
      iev = -1
      do 450 i = 1, n
         fvec(i) = d1*fvec(i)
         if (iev .gt. 0) fvec(i) = fvec(i) + one/(dble(i)**2 - one)
         iev = -iev
  450    continue
      do 470 j = 1, n
         g(j) = zero
         t1 = one
         t2 = two*x(j) - one
         t = two*t2
         s1 = zero
         s2 = two
         do 460 i = 1, n
            g(j) = g(j) + fvec(i)*s2
            th = four*t2 + t*s2 - s1
            s1 = s2
            s2 = th
            th = t*t2 - t1
            t1 = t2
            t2 = th
  460       continue
  470    continue
      d2 = two*d1
      do 480 j = 1, n
         g(j) = d2*g(j)
  480    continue
      return
c
c     Last card of subroutine grdfcn.
c
      end
