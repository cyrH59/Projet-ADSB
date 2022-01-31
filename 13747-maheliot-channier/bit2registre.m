function [registre] = bit2registre(b,latref,lonref)
     %TACHE6FUNCTION Summary of this function goes here
     %   Detailed explanation goes here
     coordinit=zeros(1,2);
     nom = "";
     trame = b(1:88);
%      trame_erreur = b(:,1);
%      %trame_erreur(1) = ~trame(1);
%      detector = crc.detector('Polynomial',[1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]);
%      test_trame = detect(detector, trame_erreur);
%      if trame == test_trame
%          %disp("on est bon")
%      else
%          disp("la trame possède une ou plusieurs erreurs")
%          return;
%      end
     registre = struct('adresse',[],'format',[],'type',[],'nom',[], ...
'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[]);
     format = trame(1:5);
     format_val = 0;
     for k=1:length(format)
         if format(k)==1
             format_val = format_val + 2^(length(format)-k);
         end
     end
     if format_val == 11
         registre.format = 'ACK';
     elseif  format_val == 17
         registre.format = 'ADS-B';
     elseif  format_val == 18
         registre.format = 'TIS-B';
     elseif  format_val == 19
         registre.format = 'ADS-B MIL';
     else
         registre.format = 'error';
     end
     capacite = trame(6:8);
     %% Calcul de l'adresse
     adresse = trame(9:32);
     hexa = ['0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'A' 'B' 'C' 'D' 'E' 'F'];
     res = '';
     for i=1:6
         coord = 1;
         for k=1:4
             if adresse((i-1)*4+k)==1
                 coord(1,1) = coord(1,1) + 2^(4-k);
             end
         end
         res = strcat(res,hexa(coord));
     end
     registre.adresse = res;
     type = trame(33:37);
     %% Calcul du type FTC
     type_val = 0;
     for k=1:length(type)
         if type(k)==1
             type_val = type_val + 2^(length(type)-k);
         end
     end
     registre.type=type_val;
     if type_val >= 1 && type_val <= 4
         %%Calcul de la categorie (facultatif)
         %%categorie = trame(38:40);
         %%categorie_val = 0;
         %%for k=1:length(categorie)
             %%if categorie(k)==1
                 %%categorie_val = categorie_val + 2^(length(categorie)-k);
             %%end
         %%end
        disp("on s'occupe du nom de l'appareil")
         %% Calcul du nom
         ID = trame(41:88);
         tab = ['-' 'P' ' ' '0' ; 'A' 'Q' '-' '1';'B' 'R' '-' '2'; 'C' 'S' '-' '3'; 'D' 'T' '-' '4';'E' 'U' '-' '5';'F' 'V' '-' '6'; 'G' 'W' '-' '7';'H' 'X' '-' '8'; 'I' 'Y' '-' '9';'J' 'Z' '-' '-';'K' '-' '-' '-';'L' '-' '-' '-';'M' '-' '-' '-';'N' '-' '-' '-';'O' '-' '-' '-'];
         resultat = '';
         for i=1:8
             coord = ones(1,2);
             for k=1:2
                 if ID((i-1)*6+k)==1
                     coord(1,2) = coord(1,2) + 2^(2-k);
                 end
             end
             for k=3:6
                 if ID((i-1)*6+k)==1
                     coord(1,1) = coord(1,1) + 2^(6-k);
                 end
             end
             resultat = strcat(resultat,tab(coord(1,1),coord(1,2)));
         end
         registre.nom = resultat;
         nom = registre.nom;
     elseif type_val >= 5 && type_val <= 8
         disp("on s'occupe des données de position au sol")
         %% On calcule la longitude et la latitude
         latitude = trame(55:71);
         longitude = trame(72:88);
         LAT = 0;
         LON = 0;
         for k=1:length(latitude)
             if latitude(k) == 1
                 LAT = LAT + 2^(length(latitude)-k);
             end
             if longitude(k) == 1
                 LON = LON + 2^(length(longitude)-k);
             end
         end
         %% Calcul de la latitude
         Nz = 15;
         Nb = 17;
         i = trame(54);
         registre.cprFlag = i;
         registre.timeFlag = trame(53);
         Dlat = 360 / (4*Nz - i);
         j = floor(latref/Dlat) + floor(0.5 + MOD(latref,Dlat)/Dlat - LAT/(2^Nb)); 
         lat = Dlat*(j+LAT/(2^Nb));
         registre.latitude = lat;

         %% Calcul de la longitude
         if cprNL(lat) - i == 0
             Dlon = 360;
         else
             Dlon = 360/(cprNL(lat)-i);
         end
         m = floor(lonref/Dlon) + floor(0.5 + MOD(lonref,Dlon)/Dlon - LON/(2^Nb));
         lon = Dlon*(m+LON/(2^Nb));
         registre.longitude = lon;
         %% Affichage de la position sur la carte
%          disp(lon)
%          disp(lat)
%          hold on
%          plot(lon,lat,'ro-');
     elseif (type_val >= 9 && type_val <= 18) || (type_val >= 20 && type_val <= 22)
         disp("on s'occupe des données de position en vol")
         %% Calcul de l'altitude
         altitude = trame(41:52);
         ra = 0 ;
         altitude(8) = [];
         for k=1:length(altitude)
             if altitude(k) == 1
                 ra = ra + 2^(length(altitude)-k);
             end
         end
         val_altitude = 25*ra - 1000 ;
         registre.altitude = val_altitude;
         latitude = trame(55:71);
         longitude = trame(72:88);
         LAT = 0;
         LON = 0;
         for k=1:length(latitude)
             if latitude(k) == 1
                 LAT = LAT + 2^(length(latitude)-k);
             end
             if longitude(k) == 1
                 LON = LON + 2^(length(longitude)-k);
             end
         end
         %% Calcul de la latitude
         Nz = 15;
         Nb = 17;
         i = trame(54);
         registre.cprFlag = i;
         registre.timeFlag = trame(53);
         Dlat = 360 / (4*Nz - i);
         j = floor(latref/Dlat) + floor(0.5 + MOD(latref,Dlat)/Dlat - LAT/(2^Nb)); 
         lat = Dlat*(j+LAT/(2^Nb));
         registre.latitude = lat;

         %% Calcul de la longitude
         if cprNL(lat) - i == 0
             Dlon = 360;
         else
             Dlon = 360/(cprNL(lat)-i);
         end
         m = floor(lonref/Dlon) + floor(0.5 + MOD(lonref,Dlon)/Dlon - LON/(2^Nb));
         lon = Dlon*(m+LON/(2^Nb));
         registre.longitude = lon;
     elseif type_val == 19
         disp("Airborne velocity")
     elseif type_val == 0
         disp("No position information")
     else
         disp("reserved")
     end
end



