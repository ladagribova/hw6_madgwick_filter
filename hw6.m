 load('accel.mat')
 load('gyr.mat')
 load('magnitude.mat')


deltat= 0.001 %sampling period in seconds (shown as 1 ms)
gyroMeasError= 3.14159265358979 * (5.0 / 180.0) 
gyroMeasDrift= 3.14159265358979 * (0.2 / 180.0) 
beta= sqrt(3.0 / 4.0) * gyroMeasError 
zeta= sqrt(3.0 / 4.0) * gyroMeasDrift

flag=0;
 SEq_1 = 1
 SEq_2 = 0
 SEq_3 = 0
 SEq_4 = 0
 b_x(1) = 1
 b_z(1) = 0
 w_bx = 0
 w_by = 0
 w_bz = 0
for t=1:1:151       
     halfSEq_1 = 0.5 * SEq_1
     halfSEq_2 = 0.5 * SEq_2
     halfSEq_3 = 0.5 * SEq_3
     halfSEq_4 = 0.5 * SEq_4
     twoSEq_1 = 2.0 * SEq_1
     twoSEq_2 = 2.0 * SEq_2
     twoSEq_3 = 2.0 * SEq_3
     twoSEq_4 = 2.0 * SEq_4
     if flag==0
     twob_x = 2.0 * b_x(t)
     twob_z = 2.0 * b_z(t)
     twob_xSEq_1 = 2.0 * b_x(t) * SEq_1
     twob_xSEq_2 = 2.0 * b_x(t) * SEq_2
     twob_xSEq_3 = 2.0 * b_x(t) * SEq_3
     twob_xSEq_4 = 2.0 * b_x(t) * SEq_4
     twob_zSEq_1 = 2.0 * b_z(t) * SEq_1
     twob_zSEq_2 = 2.0 * b_z(t) * SEq_2
     twob_zSEq_3 = 2.0 * b_z(t) * SEq_3
     twob_zSEq_4 = 2.0 * b_z(t) * SEq_4 
     flag=1;    
     else
     twob_x = 2.0 * b_x(t-1)
     twob_z = 2.0 * b_z(t-1)
     twob_xSEq_1 = 2.0 * b_x(t-1) * SEq_1
     twob_xSEq_2 = 2.0 * b_x(t-1) * SEq_2
     twob_xSEq_3 = 2.0 * b_x(t-1) * SEq_3
     twob_xSEq_4 = 2.0 * b_x(t-1) * SEq_4
     twob_zSEq_1 = 2.0 * b_z(t-1) * SEq_1
     twob_zSEq_2 = 2.0 * b_z(t-1) * SEq_2
     twob_zSEq_3 = 2.0 * b_z(t-1) * SEq_3
     twob_zSEq_4 = 2.0 * b_z(t-1) * SEq_4
     end
     SEq_1SEq_2=0
     SEq_1SEq_3 = SEq_1 * SEq_3
     SEq_1SEq_4=0
     SEq_2SEq_3=0
     SEq_2SEq_4 = SEq_2 * SEq_4
     SEq_3SEq_4=0
     twom_x = 2.0 * m_x(t)
     twom_y = 2.0 * m_y(t)
     twom_z = 2.0 * m_z(t)
   
    norm = sqrt(a_x(t) * a_x(t) + a_y(t) * a_y(t) + a_z(t) * a_z(t))
    a_x(t) = a_x(t) / norm
    a_y(t) = a_y(t) / norm
    a_z(t) = a_z(t) /norm
    
    norm = sqrt(m_x(t) * m_x(t) + m_y(t) * m_y(t) + m_z(t) * m_z(t))
    m_x(t) = m_x(t) /norm
    m_y(t) = m_y(t) /norm
    m_z(t) = m_z(t) /norm
   
    f_1 = twoSEq_2 * SEq_4 - twoSEq_1 * SEq_3 - a_x(t)
    f_2 = twoSEq_1 * SEq_2 + twoSEq_3 * SEq_4 - a_y(t)
    f_3 = 1.0 - twoSEq_2 * SEq_2 - twoSEq_3 * SEq_3 - a_z(t)
    f_4 = twob_x * (0.5 - SEq_3 * SEq_3 - SEq_4 * SEq_4) + twob_z * (SEq_2SEq_4 - SEq_1SEq_3) - m_x(t)
    f_5 = twob_x * (SEq_2 * SEq_3 - SEq_1 * SEq_4) + twob_z * (SEq_1 * SEq_2 + SEq_3 * SEq_4) - m_y(t)
    f_6 = twob_x * (SEq_1SEq_3 + SEq_2SEq_4) + twob_z * (0.5 - SEq_2 * SEq_2 - SEq_3 * SEq_3) - m_z(t)
    J_11or24 = twoSEq_3 
    J_12or23 = 2.0 * SEq_4
    J_13or22 = twoSEq_1 
    J_14or21 = twoSEq_2
    J_32 = 2.0 * J_14or21
    J_33 = 2.0 * J_11or24 
    J_41 = twob_zSEq_3 
    J_42 = twob_zSEq_4
    J_43 = 2.0 * twob_xSEq_3 + twob_zSEq_1 
    J_44 = 2.0 * twob_xSEq_4 - twob_zSEq_2 
    J_51 = twob_xSEq_4 - twob_zSEq_2 
    J_52 = twob_xSEq_3 + twob_zSEq_1
    J_53 = twob_xSEq_2 + twob_zSEq_4
    J_54 = twob_xSEq_1 - twob_zSEq_3
    J_61 = twob_xSEq_3
    J_62 = twob_xSEq_4 - 2.0 * twob_zSEq_2
    J_63 = twob_xSEq_1 - 2.0 * twob_zSEq_3
    J_64 = twob_xSEq_2
    
    SEqHatDot_1 = J_14or21 * f_2 - J_11or24 * f_1 - J_41 * f_4 - J_51 * f_5 + J_61 * f_6
    SEqHatDot_2 = J_12or23 * f_1 + J_13or22 * f_2 - J_32 * f_3 + J_42 * f_4 + J_52 * f_5 + J_62 * f_6
    SEqHatDot_3 = J_12or23 * f_2 - J_33 * f_3 - J_13or22 * f_1 - J_43 * f_4 + J_53 * f_5 + J_63 * f_6
    SEqHatDot_4 = J_14or21 * f_1 + J_11or24 * f_2 - J_44 * f_4 - J_54 * f_5 + J_64 * f_6
    
    norm = sqrt(SEqHatDot_1 * SEqHatDot_1 + SEqHatDot_2 * SEqHatDot_2 + SEqHatDot_3 * SEqHatDot_3 + SEqHatDot_4 * SEqHatDot_4)
    SEqHatDot_1 = SEqHatDot_1 / norm
    SEqHatDot_2 = SEqHatDot_2 / norm
    SEqHatDot_3 = SEqHatDot_3 / norm
    SEqHatDot_4 = SEqHatDot_4 / norm
    
    w_err_x = twoSEq_1 * SEqHatDot_2 - twoSEq_2 * SEqHatDot_1 - twoSEq_3 * SEqHatDot_4 + twoSEq_4 * SEqHatDot_3
    w_err_y = twoSEq_1 * SEqHatDot_3 + twoSEq_2 * SEqHatDot_4 - twoSEq_3 * SEqHatDot_1 - twoSEq_4 * SEqHatDot_2
    w_err_z = twoSEq_1 * SEqHatDot_4 - twoSEq_2 * SEqHatDot_3 + twoSEq_3 * SEqHatDot_2 - twoSEq_4 * SEqHatDot_1
    
    w_bx = w_bx + w_err_x * deltat * zeta
    w_by = w_by + w_err_y * deltat * zeta
    w_bz =w_bz + w_err_z * deltat * zeta
    w_x(t) = w_x(t) -w_bx
    w_y(t) = w_y(t)-w_by
    w_z(t) = w_z(t)-w_bz
    
    SEqDot_omega_1 = -halfSEq_2 * w_x(t) - halfSEq_3 * w_y(t) - halfSEq_4 * w_z(t)
    SEqDot_omega_2 = halfSEq_1 * w_x(t) + halfSEq_3 * w_z(t) - halfSEq_4 * w_y(t)
    SEqDot_omega_3 = halfSEq_1 * w_y(t) - halfSEq_2 * w_z(t) + halfSEq_4 * w_x(t)
    SEqDot_omega_4 = halfSEq_1 * w_z(t) + halfSEq_2 * w_y(t) - halfSEq_3 * w_x(t)
    
    SEq_1 = SEq_1 +(SEqDot_omega_1 - (beta * SEqHatDot_1)) * deltat
    SEq_2 = SEq_2 +(SEqDot_omega_2 - (beta * SEqHatDot_2)) * deltat
    SEq_3 = SEq_3 +(SEqDot_omega_3 - (beta * SEqHatDot_3)) * deltat
    SEq_4 = SEq_4 +(SEqDot_omega_4 - (beta * SEqHatDot_4)) * deltat
    
    norm = sqrt(SEq_1 * SEq_1 + SEq_2 * SEq_2 + SEq_3 * SEq_3 + SEq_4 * SEq_4)
    SEq_1 = SEq_1 /norm
    SEq_2 = SEq_2 /norm
    SEq_3 = SEq_3 /norm
    SEq_4 =SEq_4 / norm
    SEq_1SEq_2 = SEq_1 * SEq_2
    SEq_1SEq_3 = SEq_1 * SEq_3
    SEq_1SEq_4 = SEq_1 * SEq_4
    SEq_3SEq_4 = SEq_3 * SEq_4
    SEq_2SEq_3 = SEq_2 * SEq_3
    SEq_2SEq_4 = SEq_2 * SEq_4
    h_x(t) = twom_x * (0.5 - SEq_3 * SEq_3 - SEq_4 * SEq_4) + twom_y * (SEq_2SEq_3 - SEq_1SEq_4) + twom_z * (SEq_2SEq_4 + SEq_1SEq_3)
    h_y(t) = twom_x * (SEq_2SEq_3 + SEq_1SEq_4) + twom_y * (0.5 - SEq_2 * SEq_2 - SEq_4 * SEq_4) + twom_z * (SEq_3SEq_4 - SEq_1SEq_2)
    h_z(t) = twom_x * (SEq_2SEq_4 - SEq_1SEq_3) + twom_y * (SEq_3SEq_4 + SEq_1SEq_2) + twom_z * (0.5 - SEq_2 * SEq_2 - SEq_3 * SEq_3)
    
    b_x(t) = sqrt((h_x(t) * h_x(t)) + (h_y(t) * h_y(t)))
    b_z(t) = h_z(t)
end    

 
 figure(1)
 plot3(h_x,h_y,h_z)
 figure(2)
 plot(b_x,b_z)