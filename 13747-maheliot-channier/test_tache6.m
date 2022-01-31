function [] = test_tache6(b)
%TEST_TACHE6 Summary of this function goes here
%   Detailed explanation goes here
% A lancer avec adsb_msgs en argument
    ref_lat = 44.8069;
    ref_lon = -0.6066;
    addpath(genpath('src'))
    affiche_carte(ref_lon,ref_lat);
    xlim([-1.36,0.7]);
    ylim([44.46,45.17]);
    nom = "first";
    final_lon = 0;
    final_lat = 0;
    for colonne=1:27
        registre = bit2registre(b(:,colonne),ref_lat,ref_lon);
%         if strcmp(registre.nom,"")
%             coordinit(1,1) = registre.longitude;
%             coordinit(1,2) = registre.latitude;
%             hold on
%             plot(coordinit(1),coordinit(2),".");
%         end  
        if(strcmp(registre.longitude,""))
        else 
            final_lon = registre.longitude;
        end
        if(strcmp(registre.longitude,""))
        else 
            final_lat = registre.latitude;
        end
        %% Affichage de la position sur la carte
         hold on
         plot(registre.longitude,registre.latitude,'o-r');
         if (colonne == length(b(1,:))-2)
            nom = registre.nom;
            disp(nom);
         end
         if colonne == length(b(1,:))
            text(final_lon,final_lat,strcat('\leftarrow',nom));
         end
    end
end

