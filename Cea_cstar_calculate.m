Function cstar=Cea_cstar_calculate(eff,OF,pc,propellent_properties,aeat)

       fw=fopen('cstar_cal.inp','w');
       fprintf(fw,'problem \r\n');
       fprintf(fw,'case=%1.2f \r\n',eff);
       fprintf(fw,'o/f=%1.2f \r\n',OF);
       fprintf(fw,'rocket equilibrium \r\n');
       fprintf(fw,'test,k=3800 \r\n');
       fprintf(fw,'p,psia=%1.2f \r\n',pc);
       fprintf(fw,'supar=%1.2f \r\n',aeat);
       fprintf(fw,'react \r\n');
       fprintf(fw,'oxid=O2 wt=55.28 t,k=1144\r\n');
       fprintf(fw,'oxid=H2O wt=44.72 t,k=1144\r\n');
       fprintf(fw,'fuel=%s \r\n',propellent_properties.fuelname1);
       fprintf(fw,'fuel=%s \r\n',propellent_properties.fuelname2);
       fprintf(fw,'fuel=%s \r\n',propellent_properties.fuelname3);
       fprintf(fw,'output \r\n');
       fprintf(fw,'siunits \r\n');
       fprintf(fw,'plot p t gam me pip isp son \r\n');
       fprintf(fw,'end\r\n');
       fclose(fw);

       system('FCEA2.exe<auto.inp');
  
       [pressure,temp,gamma,mole_weight,sonic]=textread('cstar_cal.plt','%f%f%f%f%f','commentstyle','shell');

       % read data from .plt. --> read 5 parameters at 3 position --> position 1 = chamber, position 2= throat, position 3 = nozzle exit.

        ga=gamma(1);% chamber gamma
        Velocity=sonic(1);
        Ga=ga*(((2/(ga+1))^((ga+1)/(ga-1)))^0.5);
        cstar=velocity/Ga;

end
