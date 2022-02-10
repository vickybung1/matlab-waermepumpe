classdef GebaeudefuerWaermepumpen
#hallo das ist eine Änderung
    properties 
        profil
        stochastischesWaermeprofil
        stochastischesStromprofil
        jahresEnergieMengeWaerme
        jahresEnergieMengeStrom
        wp_Typ
        pufferspeicherTyp
        heizstabTyp
        %und andere Scheiße die ich gerade nicht brauche

    end 

    function ThisGebaeudeObj = gebaeudeAllgemeinfuerWaermepumpe(profil)
    
        ThisGebaeudeObj.GewaehltesProfil = profil; %hier wird einfach nur das Profil eingegeben

        ThisGebaeudeObj.stochastischesWaermeprofil = ThisGebaeudeObj.waermeProfilFkt(); %hier wird später eine Funktion erstellt, die das Waermeprofil einlädt

        %usw. 

    end 

    %was hier passiert ist erstmal egal; zunächst wird das Waermeprofil
    %eingeladen, das zu dem spezifischen Profil des Gebaeudes gehört, die
    %Jahresenergiemenge berechnet in kWh und das gleiche mit dem
    %Stromprofil gemacht. Das Stromprofil brauche ich aber erstmal nur,
    %damit hier später der elektrische Energieverbrauch der Waermepumpe
    %hinzuaddiert wird. 

    function Waermepumpe = wp_Typ(ThisGeb)

        load TempVerlaufFinal.mat %hier werden alle vorhandenen Temperaturverläufe eingeladen

        StelleBivalenztemperatur = find(TempVerlaufFinal==-5,'first'); %hier war schon der erste Fehler-Lösung evtl so dass hier die erste Stelle gewählt wird an der Temperatur auftritt
        
        BivalenzHeizlastGebaeude = ThisGeb.stochastischesWaermeProfil(StelleBivalenztemperatur); %find kommt weg, es wird überhaupt keine Stelle gesucht, sondern der tatsächliche Wert also die thermische Leistung an der Stelle der Bivalenztemperatur 

        %PROBLEM: ich muss gucken wie stark der Wärmeverlauf schwankt um zu
        %gucken, ober der Wert hier so überhaupt zuverlässig ist.

        OptLeistungWP = BivalenzHeizlastGebaeude; 

        [BetriebsdatenWP] = xlsread('BetriebsdatenWP.xlsx'); %ich hab jetzt die Matrix der Betriebsdaten der Wärmepumpe - hier muss festgehalten werden, was was bedeutet

        elektrischeNennleistungWP = BetriebsdatenWP(:,2);

        for elektrischeNennleistungWP(:)>OptLeistungWP

        NennleistungdieserWP = min(abs(elektrischeNennleistungWP(:)-OptLeistungWP));

        end 

        %es wird hier die Wärmepumpe gewählt deren elektrische Nennleistung
        %am nächsten an der optimalen Leistung im Bivalenzpunkt liegt. Ist
        %es wichtig, dass das z.B. zu groß oder zu klein dimensioniert ist,
        %dann muss vorher eingegeben werden, dass A-B nicht negativ sein
        %darf durch for-Schleife
        % 
        % keine Ahnung wofür dieses (:) ist muss ggf weg!. 

        Waermepumpe = NennleistungdieserWP;

        %Frage: wie soll das ganze jetzte it WaermepumpeAllgemein verknüpft
        %werden wofür ist das überhaupt

          function Heizstab = heizstabTyp(ThisGeb)

              % der Heizstab wirdd jetzt in der Funktion der Waermepumpe
              % bestimmt weil das eine das andere bedingt kann aber auch
              % sein, dass man die Parameter einer getrennnten Funktion
              % übergeben kann

              OptLeistungHeizstab = max(ThisGeb.stochastischesWaermeprofil) - ThisGeb.WP_Typ;  

              for OptLeistung Heizstab < %auf vorherige Klasse zugreifen mit verschiedenen heizstäben

              Heizstab = min(abs(dieserWertvonoben - OptLeistungheizstab));

              end                              
        
          end 

    end 
    

  
end 
