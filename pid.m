###########################################
# Simulation of a PI Controller           #
# fabianb,  09/2017                       #
###########################################

clear;
# Number of samples taken for the simulation
length = 300;
# calculate error based on samples in the past
offset = 2;

# t_ptp is the common time base of two systems
t_ptp = 0:1:length; # startpoint : increment value for common time base : endpoint

# t_media_soll is the media time of system 1 refered to the common time base t_ptp
t_media_soll = t_ptp * 0.9 + sin(t_ptp); # 0.9 run slower than the tiem reference, sin to have some error in there

# t_media_step is the increment value of the media time of system 2 when it is uncontrolled/freewheeling
t_media_step = 1.1; # 1.1 run faster than time reference

# t_media_ist is the current time of system 2 refered to the common timebase. 
# It is incremented and controlled in the for loop below.
t_media_ist = t_ptp;

# t_media_error is added as error signal to t_media_ist
t_media_error = rand(length+1)*5-2.5; 
#t_media_error = sin(t_ptp*0.5);

# Control loop  
for i=2+offset:1:length
  t_media_ist(i) = t_media_ist(i) + t_media_step + t_media_error(i);
  ierror(i) = t_media_ist(i-offset) - t_media_soll(i-offset);
  perror(i) = ierror(i-offset) - ierror(i-offset-1);
  t_media_ist(i+1) = t_media_ist(i) - ierror(i) * 0.05 - perror(i) * 0.2;
endfor
ierror(length+1) = 0;
perror(length+1) = 0;
   
# Claculate absolute error
error = t_media_ist - t_media_soll;

     
# Plot the timing values 
figure(1);
plot (t_ptp, t_ptp, '-', t_ptp, t_media_soll, '--', t_ptp, t_media_ist, '--');
#axis ([0 length+1 -10 length+10]); #[x_lo x_hi y_lo y_hi]

# Plot the error signals
figure(2);
plot ( t_ptp, error, '-', t_ptp, ierror, '--', t_ptp, perror, '.');
#axis ([0 length+1 -20 20]); #[x_lo x_hi y_lo y_hi]