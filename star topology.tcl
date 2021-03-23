#Creating simulator object 
set ns [new Simulator]   

#Creating the nam file
set nf [open out.nam w]      
#It opens the file 'out.nam' for writing and gives it the file handle 'nf'. 
$ns namtrace-all $nf

#Finish Procedure  (closes the trace file and starts nam) 
proc finish {} {
        global ns nf
        $ns flush-trace
        close $nf
        exec nam out.nam &
        exit 0
        }
#The trace data is flushed into the file by using command $ns flush-trace and then file is closed.

$ns color 0 blue
$ns color 1 red

#creating nodes ,their links and setting up orientation
set SW1 [$ns node]
set H(1) [$ns node]
$ns duplex-link $H(1) $SW1 512Kb 10ms SFQ
$ns duplex-link-op $H(1) $SW1 orient right-down

set H(2) [$ns node]
$ns duplex-link $H(2) $SW1 512Kb 10ms SFQ
$ns duplex-link-op $H(2) $SW1 orient left-down

set H(3) [$ns node]
$ns duplex-link $H(3) $SW1 512Kb 10ms SFQ
$ns duplex-link-op $H(3) $SW1 orient left

set H(4) [$ns node]
$ns duplex-link $H(4) $SW1 512Kb 10ms SFQ
$ns duplex-link-op $H(4) $SW1 orient left-up

set H(5) [$ns node]
$ns duplex-link $H(5) $SW1 512Kb 10ms SFQ
$ns duplex-link-op $H(5) $SW1 orient right-up

set H(6) [$ns node]
$ns duplex-link $H(6) $SW1 512Kb 10ms SFQ
$ns duplex-link-op $H(6) $SW1 orient right


$ns rtproto DV

#Creating a TCP agent,Specifying tcp traffic to have blue color and attaching it to n1
set tcp0 [new Agent/TCP]
$ns attach-agent $H(1) $tcp0
$tcp0 set fid_ 1       
#Creating a Sink Agent and attaching it to n3,Connecting TCP agent with Sink agent
set sink0 [new Agent/TCPSink]
$ns attach-agent $H(4) $sink0
$ns connect $tcp0 $sink0
#Creating FTP agent for traffic and attaching it to tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0



#Creating a UDP agent,Specifying udp traffic to have red color and attaching it to n0
set udp0 [new Agent/UDP]
$udp0 set fid_ 0        
$ns attach-agent $H(2) $udp0
#Creating the Null agent,Attaching it to n3 and connecting it with udp agent
set null0 [new Agent/Null]
$ns attach-agent $H(5) $null0     
$ns connect $udp0 $null0
#Creating the CBR agent to generate the traffic over udp0 agent ,and attaching cbr0 with udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set rate_ 256Kb
$cbr0 attach-agent $udp0

#Bring the link between SW1 and H5 down at 0.5 and bring it back up at 0.9
$ns rtmodel-at 0.5 down $SW1 $H(5)
$ns rtmodel-at 0.9 up $SW1 $H(5)

#Bring the link between SW1 and H4 down at 0.7 and bring it back up at 1.2
$ns rtmodel-at 0.7 down $SW1 $H(4)
$ns rtmodel-at 1.2 up $SW1 $H(4)

#Starting the FTP Traffic
$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"

#Starting the cbr traffic
$ns at 0.2 "$cbr0 start"
$ns at 1.3 "$cbr0 stop"

#Calling the finish procedure
$ns at 2.0 "finish"

#Run the simulation
$ns run

#doneq2