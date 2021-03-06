package triangle;

//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

import inet.nodes.inet.StandardHost;
import inet.nodes.ethernet.EtherSwitch;
import inet.linklayer.ethernet.EtherHub;

import channels.ProgramedFailureChannel;

network Triangle
{
    @display("bgb=586,362");
    submodules:
        SW_A: EtherSwitch {
            @display("p=189,96");
            relayUnitType = "MACRelayUnitSTPNP";
        }
        SW_B: EtherSwitch {
            @display("p=379,96");
            relayUnitType = "MACRelayUnitSTPNP";
        }
        SW_C: EtherSwitch {
            @display("p=278,239");
            relayUnitType = "MACRelayUnitSTPNP";
        }
        C: StandardHost {
            @display("p=278,319");
            routingFile = "C.rt";
        }
        A: StandardHost {
            @display("p=75,37");
            routingFile = "A.rt";
        }
        B: StandardHost {
            @display("p=500,37");
            routingFile = "B.rt";
        }
    connections:
        B.ethg++ <--> SW_B.ethg++;
        A.ethg++ <--> SW_A.ethg++;
        C.ethg++ <--> SW_C.ethg++;
        SW_A.ethg++ <--> SW_C.ethg++;
        SW_A.ethg++ <--> SW_C.ethg++;
        SW_C.ethg++ <--> SW_B.ethg++;
        SW_B.ethg++ <--> ProgramedFailureChannel { failureAt="70s"; recoveryAt="280s"; } <--> SW_A.ethg++;
}

network TriangleHub_BC
{
    @display("bgb=586,362");
    submodules:
        SW_A: EtherSwitch {
            @display("p=189,96");
            relayUnitType = "MACRelayUnitSTPNP";
        }
        SW_B: EtherSwitch {
            @display("p=379,96");
            relayUnitType = "MACRelayUnitSTPNP";
        }
        SW_C: EtherSwitch {
            @display("p=278,239");
            relayUnitType = "MACRelayUnitSTPNP";
        }
        C: StandardHost {
            @display("p=278,319");
            routingFile = "C.rt";
        }
        A: StandardHost {
            @display("p=75,37");
            routingFile = "A.rt";
        }
        B: StandardHost {
            @display("p=500,37");
            routingFile = "B.rt";
        }
        etherHub: EtherHub {
            @display("p=379,182");
        }
        D: StandardHost {
            @display("p=500,189");
            routingFile = "D.rt";
        }
    connections:
        B.ethg++ <--> SW_B.ethg++;
        A.ethg++ <--> SW_A.ethg++;
        C.ethg++ <--> SW_C.ethg++;
        D.ethg++ <--> etherHub.ethg++;
        
        // Backup links between SW_A and SW_C  
        SW_A.ethg++ <--> SW_C.ethg++;
        SW_A.ethg++ <--> SW_C.ethg++;
        
        // link between SW_B and SW_A 
        SW_B.ethg++ <--> ProgramedFailureChannel { failureAt="70s"; recoveryAt="280s"; } <--> SW_A.ethg++;

		// redundant link between C and the network segment
        SW_C.ethg++ <--> etherHub.ethg++; // alternate
        SW_C.ethg++ <--> etherHub.ethg++; // alternate

		// redundant link between B and the network segment 
        SW_B.ethg++ <--> etherHub.ethg++;  // designated link to the segment
        SW_B.ethg++ <--> etherHub.ethg++;  // backup
}
