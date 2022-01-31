function [liste_registre_avion] = tache8(buff)
%TACHE8 Summary of this function goes here
%   Detailed explanation goes here
    close all
    clc
    addpath(genpath('src'))
    fse = 4;
    ref_lat = 44.8069;
    ref_lon = -0.6066;
    figure;
    affiche_carte(ref_lon,ref_lat);
    xlim([-1.36,0.7]);
    ylim([44.46,45.17]);
    xlabel("longitude en degrés");
    ylabel("latitude en degrés");
    bits = zeros(120,1);
    tous_les_registres = bit2registre(bits(9:120,1),ref_lat,ref_lon);
    liste_adresse_avions = ["" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""];
    liste_registre_avion = bit2registre(bits(9:120,1),ref_lat,ref_lon);
    i = 1;
    for colonne=1:length(buff(1,:))
        registre = tache8_recepteur(buff(:,colonne),fse);
        for registrecolonne=1:length(registre(1,:))
             tous_les_registres(i) = registre(1,registrecolonne) ;
             i = i+1 ;
        end
    end
    k = 1;
    j = 1;
    for r=1:length(tous_les_registres(1,:))
        for n=1:r-1
            if strcmp(tous_les_registres(1,r).adresse,liste_adresse_avions(n)) == 1
                k = k+1;
            else
                %on fait rien
            end
        end
        if (k==1)
            liste_adresse_avions(j) = tous_les_registres(1,r).adresse;
            j = j + 1;
            k = 1;
        else 
            k = 1;
        end
    end
    i = 1;
    for avion=1:length(liste_adresse_avions)
        for r=1:length(tous_les_registres)
            if strcmp(tous_les_registres(1,r).adresse,liste_adresse_avions(avion)) == 1
                %On s'occupe ici de remplir le tableau liste_registre_avion
                liste_registre_avion(avion,i) = tous_les_registres(1,r);
                i = i+1;
            end
        end
        i = 1;
    end
    for i=1:length(liste_registre_avion(:,1))
        final_lon = 0;
        final_lat = 0;
        nom = liste_adresse_avions(i) ;
        for j=1:length(liste_registre_avion(1,:))
            if(strcmp(liste_registre_avion(i,j).longitude,""))
            %elseif(strcmp(liste_registre_avion(i,j).longitude,"") == 0)
            elseif(isempty(liste_registre_avion(i,j).longitude) == 0)
                %disp("on vient malheuresement là");
                final_lon = liste_registre_avion(i,j).longitude;
                final_lat = liste_registre_avion(i,j).latitude;
            end
            hold on
            plot(liste_registre_avion(i,j).longitude,liste_registre_avion(i,j).latitude,'o-r');
            %if strcmp(liste_registre_avion(i,j).nom,"")
            if isempty(liste_registre_avion(i,j).nom) == 1
            else
                disp("on vient malheuresement ici aussi");
                nom = liste_registre_avion(i,j).nom;
            end
            disp(final_lon);
            disp(final_lat);
            disp(j)
            disp(nom)
        end
        text(final_lon,final_lat,strcat('\leftarrow',nom));
    end
%         hold on
%         plot(registre(1,r).longitude,registre(1,r).latitude,"r*");
%         if strcmp(registre(1,r).nom,"[]") == 0
%             text(registre(1,r).longitude,registre(1,r).latitude,strcat('\leftarrow',registre(1,r).nom));
%         end
end

