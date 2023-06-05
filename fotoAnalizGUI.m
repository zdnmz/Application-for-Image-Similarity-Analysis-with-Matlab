function fotoAnalizGUI()
    % GUI paneli oluşturma
    panel = uifigure('Name', 'Fotoğraf Analizi', 'Position', [100 100 600 400]);

    % Fotoğraf yükleme düğmeleri
    yukleButton1 = uibutton(panel, 'Text', 'Fotoğraf 1 Yükle', 'Position', [50 300 150 30], 'ButtonPushedFcn', @fotoYukle1);
    yukleButton2 = uibutton(panel, 'Text', 'Fotoğraf 2 Yükle', 'Position', [50 250 150 30], 'ButtonPushedFcn', @fotoYukle2);
    analizButton = uibutton(panel, 'Text', 'Analiz Et', 'Position', [50 200 150 30], 'ButtonPushedFcn', @analizEt);
    sifirlaButton = uibutton(panel, 'Text', 'Sıfırla', 'Position', [50 150 150 30], 'ButtonPushedFcn', @sifirla);

    % Butonları devre dışı bırak
    yukleButton2.Enable = 'off';
    analizButton.Enable = 'off';
    sifirlaButton.Enable = 'off';

    % Benzerlik oranı gösterimi
    benzerlikText = uitextarea(panel, 'Position', [250 200 300 130]);

    % Seçilen fotoğraf verileri
    foto1 = [];
    foto2 = [];
    rgb1 = [];
    rgb2 = [];

    function fotoYukle1(src, event)
        [filename, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Resim Dosyaları (*.jpg, *.png, *.bmp)'});
        if isequal(filename, 0) || isequal(path, 0)
            return;
        end
        foto1 = imread(fullfile(path, filename));
        rgb1 = reshape(foto1,[],3); % RGB değerlerini kaydet
        benzerlikText.Value = '';
        showTooltip(panel, 'Fotoğraf 1 yüklendi.', 3);
        yukleButton1.Enable = 'off'; % Fotoğraf 1 yüklendikten sonra butonu devre dışı bırak
        yukleButton2.Enable = 'on'; % Fotoğraf 1 yüklendikten sonra Fotoğraf 2 butonunu etkinleştir
    end

    function fotoYukle2(src, event)
        [filename, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Resim Dosyaları (*.jpg, *.png, *.bmp)'});
        if isequal(filename, 0) || isequal(path, 0)
            return;
        end
        foto2 = imread(fullfile(path, filename));
        rgb2 = reshape(foto2,[],3); % RGB değerlerini kaydet
        benzerlikText.Value = '';
        showTooltip(panel, 'Fotoğraf 2 yüklendi.', 3);
        yukleButton2.Enable = 'off'; % Fotoğraf 2 yüklendikten sonra butonu devre dışı bırak
        analizButton.Enable = 'on'; % Fotoğraf 2 yüklendikten sonra Analiz Et butonunu etkinleştir
    end

    function analizEt(src, event)
        if isempty(foto1) || isempty(foto2)
            msgbox('Lütfen önce iki fotoğrafı da yükleyin.');
            return;
        end

        % Fotoğrafların boyutlarını eşitleyin
        boyutlar = size(foto2);
        foto1 = imresize(foto1, boyutlar(1:2));
        
        % Her bir pikselin değerini karşılaştırarak benzerlik oranını hesapla
        benzerlikOrani = 0;
        grupSayisi = 5;
        grupBuyuklugu = 256 / grupSayisi;
        
        for i = 1:numel(rgb1(:, 1))
            r1 = ceil(rgb1(i, 1) / grupBuyuklugu);
            g1 = ceil(rgb1(i, 2) / grupBuyuklugu);
            b1 = ceil(rgb1(i, 3) / grupBuyuklugu);
            
            r2 = ceil(rgb2(i, 1) / grupBuyuklugu);
            g2 = ceil(rgb2(i, 2) / grupBuyuklugu);
            b2 = ceil(rgb2(i, 3) / grupBuyuklugu);
            
            if r1 == r2 && g1 == g2 && b1 == b2
                benzerlikOrani = benzerlikOrani + 1;
            end
        end
        
        benzerlikOrani = benzerlikOrani / numel(rgb1(:, 1));

        % Benzerlik metnini oluştur
        benzerlikMetni = sprintf('Benzerlik Oranı: %.2f', benzerlikOrani);

        % Benzerlik metnini göster
        benzerlikText.Value = benzerlikMetni;
        analizButton.Enable = 'off'; % Analiz Et butonunu devre dışı bırak
        sifirlaButton.Enable = 'on'; % Analiz tamamlandıktan sonra Sıfırla butonunu etkinleştir
    end

    function sifirla(src, event)
        foto1 = [];
        foto2 = [];
        rgb1 = [];
        rgb2 = [];
        benzerlikText.Value = '';
        yukleButton1.Enable = 'on'; % Sıfırla butonuna basıldığında Fotoğraf 1 Yükle butonunu etkinleştir
        yukleButton2.Enable = 'off'; % Sıfırla butonuna basıldığında Fotoğraf 2 Yükle butonunu devre dışı bırak
        analizButton.Enable = 'off'; % Sıfırla butonuna basıldığında Analiz Et butonunu devre dışı bırak
        sifirlaButton.Enable = 'off'; % Sıfırla butonunu devre dışı bırak
    end

    function showTooltip(parent, message, duration)
        % Tooltip panelini oluştur
        tooltipPanel = uipanel(parent, 'Visible', 'off', 'Position', [0 0 200 50], 'BackgroundColor', 'white');

        % Tooltip metnini oluştur
        tooltipText = uilabel(tooltipPanel, 'Text', message, 'Position', [10 10 180 30]);

        % Tooltip panelini görünür yap
        tooltipPanel.Visible = 'on';

        % Süre boyunca beklet
        pause(duration);

        % Tooltip panelini gizle
        tooltipPanel.Visible = 'off';
    end
end
