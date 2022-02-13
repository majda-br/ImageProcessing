% fonction visu_base(base,arretimage)
% base : nom du r�pertoire contenant la base d'images
% type_image_base : type des images dans la base
% arretimage : si 0, le d�filement est continu, si 1, il faut appuyer sur
% une touche pour obtenir le d�filement image par image.
function visu_base(base,type_image_base,arretimage)
if nargin==0      % si on donne aucun argument � visu_base, faire d�filer toutes les photos en continu
    base='appr';
    type_image_base='png';
    arretimage=0;
end
close all
liste=dir(fullfile(base,['*.' type_image_base]));    %recup�re toutes les images png
set(figure,'Units','normalized','Position',[5 5 90 85]/100)
for n=1:length(liste)
    nom=liste(n).name;
    Y=double(imread(fullfile(base,nom)))/255;   
    fid=fopen(fullfile(base,[nom(1:strfind(nom,'.')-1) '.txt']),'r');
    classe=fscanf(fid,'%d');
    fclose (fid);
    subplot(1,2,1)
    imshow(Y),title(['fichier ' nom ', classe ' int2str(classe)]),drawnow
    subplot(1,2,2)
    % on peut ici rajouter le code associ� � diff�rents traitements
    BW = imbinarize(Y);  % BW est l'image binaire
    imshow(BW),title('image binaire'),drawnow
    
    B=bwboundaries(BW);
    % en supposant qu'il n'y a qu'un objet dans l'image
    % z est un tableau � L lignes et 2 colonnes avec � chaque ligne les coordonn�es
    % des L points du contours sous la forme (ligne,colonne)
    z=B{1};
    % z est un tableau de complexes avec par convention une partie
    % r�elle qui est la seconde colonne du tableau et une partie 
    % imaginaire qui est la premi�re colonne
    z=z(:,2)+1i*z(:,1);  %tableau avec une colonne
    
    coeff=dfdir(z,15);
    contfil=dfinv(abs(coeff), 1000);
  
    plot(real(contfil),imag(contfil))
    
    props=regionprops(BW,'Perimeter', 'Area', 'solidity');
    Areas=[props.Area];
    Perimeters=[props.Perimeter];
    circularities=(4 * pi * Areas) ./ Perimeters .^2 
    Solidities=[props.Solidity]
    
    
    if arretimage
        pause()
    end
end