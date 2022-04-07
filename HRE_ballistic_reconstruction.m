%%% test data reconstruction  %%%
         
         load('testdata.mat')
         
         
         %eff=cstar_efficiency;
         delta_time= testdata.dt;
         At=testdata.At;                    %nozzle throat area cm^2
         aeat=testdata.aeat:
         
         j=1;k=1;fuel_checkpoint=1;
         mass.fuel_test=testdata.total_fuel_weight;
         mass.fuel=0;                  % initial consuming mass fuel (g)
         d(1)=testdata.initialD_grain; %(cm)
         L=testdata.grain_length;     %(cm)
         density=testdata.grain_density;    %g/cm^3
         pc=testdata.chamberP;               %psi
         massdot.ox=testdata.oxflowrate;     %g/s
         datalength=Length(testPc);
         time(1)=0;
         ofratio(1)=testdata.initial_OF_ratio;  % set up initial o/f value. Calculated from geometrical shape.
         
      while abs(fuel_checkpoint) > 0.001 
             pcatdt=0;modt=0;mass.fuel=0;
         for k=1:datalength
             exaim=0;
             for OF=0.5:0.1:15
                  
                 [cstar]=Cea_cstar_calculate(eff,OF,pc(k),testdata.propellant_properties,aeat(k));
         
             
                 C=cstar*eff;
                 massdot.propellant=(pc(k)*1000*9.80665*0.070306958*At(k))/C;    % g/s
                 massdot.fuel=massdot.propellant-msaadot.ox(k);
                     if massdot.fuel <= 0  % if fuel mass flow rate < 0, try another o/f ratio
                     
                          continue

                     else
                          if abs(massdot.ox/massdot.fuel)-OF) > 0.001   % if o/f is not eaqual to OF, try another o/f

                              continue
                           else

                               exaim=1;   % for mo/if eaquals to O/F
                               break
                           end 
                      end
                  end   % End of OF search

                   if exaim ==0 && ==1 % if there is no appropriate OF value, massdot.fuel=0

                      massdot.fuel=0;
                      r(k)=0;  %regression rate
                      G(k)=(4*massdot.ox(k))/(pi*d(k)^2)*0.001*10000; % kg/s*m^2
                      d(k+1)=d(k)+2*r(k)*delta_time;
                      mass.fuel=mass.fuel+massdot.fuel+delta_time;  %total mass of fuel
                      time(k+1)=time(k)+delta_time;
                      ofratio(k+1)=ofratio(k);
                   elseif exaim==0.  
                      massdot.fuel=0;
                      r(k)=r(k-1);  %
                      G(k)=(4*massdot.ox(k))/pi*d(k)^2)*0.001*10000; %kg/s*m^2
                      d(k+1)=d(k)+2*r(k)*delta_time;
                      mass.fuel=mass.fuel+massdot.fuel*delta_time;
                      time(k+1)=time(k)+delta_time;
                      ofratio(k+1)=ofratio(k);
                      continue
                    else
                      r(k)=massdot.fuel/(density*pi*d(k)*L); % cm/s
                      G(k)=(4*mo(k))/(pi*d(k)^2)*0.001*10000 ; % kg/s*m^2
                      d(k+1)=d(k)+2*r(k)*delta_time;            % cm
                      mass.fuel=mass.fuel+massdot.fuel*delta_time; % g/s
                      time(k+1)=(massdot.ox(k)/massdot.fuel);
                    end
                     
                       pcatdt=pcatdt+pc(k)*At(k)*delta_time;
                       modt=modt+mo(k)*delta_time;
                       cstar_ave_theory=cstar*delta_time;
                 end
    fuel_checkpoint=1-(mass.fuel/mass.fuel_test)

     % update cstar efficiency
       %  cstar_ave_RT=(pcatdt/(modt+mass.fuel));
       %  eff=(cstar_ave_RT/cstar_ave_theory);
      if abs(fuel_checkpoint) > 0.001  
         if fuel_checkpoint > 0
              eff=eff+0.01;
         else
              eff=eff-0.01;
         end
      end  
end 

%%%%%%%%%%%%%%%%% Finish all time history data calculate%%%%%%

Result.OF=OF;
Result.efficiency=eff;
Result.mf=massdot.fuel;
Result.regression=r;  
Result.oxflux=G;
Result.grainD=d;
Result.total_fuel=mass.fuel;

Save('Result')
plot(G,r)
figure(2);
plot(time(1:datalength),r(1:datalength))
figure(3);
plot(time(1:datalength),d(1:datalength))
figure(4);
plot(time(1:datalength),ofratio(1:datalength))   
             continue
                   
