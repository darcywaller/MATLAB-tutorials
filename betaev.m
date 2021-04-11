% Settings
window = [-.5 1]; % event windows in secs relative to event
srate = 500; % our sampling rate
frequencies = 15:29; % beta frequencies used here
cycles = 7; % number of cycles for complex wavelets
mediancutoff = 6; % amplitude threshold for beta bursts

%% Beta event detection
% load data file here 
EEG = pop_loadset('Subject122.set'); % preprocessed EEG data

% make time vector for wavelet
time = -1:1/EEG.srate:1;
% pre assign vector for wavelet
wavelet_conv_data = zeros(length(frequencies),EEG.pnts);

% go through channels
for ic = 1:EEG.nbchan
    
    
    % clone original EEG structure to use for wavelet-convolved data
    tEEG = EEG; % except, we're saving freqs in first dimension
    
    % go through frequencies
    for ifr = 1:length(frequencies) % 15-29Hz
        
        % freqs and cycles
        f = frequencies(ifr);
        s = cycles/(2*pi*f); % based on # cycles to include, figure out size of Gaussian window
        % sine and gaussian
        sine_wave = exp(1i*2*pi*f.*time); % equation to make our sine wave
        gaussian_win = exp(-time.^2./(2*s^2));
        % normalization factor
        normalization_factor = 1 / (s * sqrt(2* pi));
        % make wavelet
        wavelet = normalization_factor .* sine_wave .* gaussian_win;
        halfwaveletsize = ceil(length(wavelet)/2); % half of the wavelet size
        
        % convolve with data
        n_conv = length(wavelet) + EEG.pnts - 1; %number of points to convolve
        % fft
        fft_w = fft(wavelet,n_conv); 
        fft_e = fft(EEG.data(ic,:),n_conv); 
        ift   = ifft(fft_e.*fft_w,n_conv); 
        % get power, cutting around ends of data (at size of wavelet) to
        % remove any edge artifacts
        wavelet_conv_data(ifr,:) = abs(ift(halfwaveletsize:end-halfwaveletsize+1)).^2;
        
    end
    
    % insert
    tEEG.data = wavelet_conv_data;
    tEEG.nbchan = 1:length(frequencies); tEEG.chanlocs = []; tEEG.icaweights = []; tEEG.icawinv = [];
    
    % epoch the data
    eEEG = pop_epoch(tEEG,{'S200' 'S  1' 'S  2'},window);
    epochs = eEEG.data;
    eventsample = abs(window(1)*EEG.srate); % onset of event within epoch
    
    % get frequency medians
    fmedian = zeros(size(epochs,1),1);
    for ifr = 1:size(epochs,1)
        % take data of that freq, get medians for each epoch, average them
        fmedian(ifr,1) = mean(median(squeeze(epochs(ifr,:,:))));
    end
    
    % go through trials
    if ic == 1; eventnums = zeros(EEG.nbchan,size(eEEG.data,1)); end % preassign
    for it = 1:size(epochs,3) % go through epochs
        
        % Quantify beta peaks wrt amplitude cutoff
        % Note this script is ambivalent to exact freq and you can have
        % multiple bursts in the same/diff freqs. Also note that power
        % values are not super meaningful and hard to interpret alone in
        % absence of a baseline correction.
        
        % get trial TF data (from event to SSRT)
        tdata = squeeze(epochs(:,eventsample+1:end,it));
        % find local maxima
        [peakF,peakT] = find(imregionalmax(tdata));
        % get power for events
        peakpower = zeros(length(peakF),4); % column 1 = value, column 2 =  above threshold
        for ie = 1:length(peakF)
            peakpower(ie,1) = tdata(peakF(ie),peakT(ie)); % pull power at that point
            if peakpower(ie,1) > mediancutoff*fmedian(peakF(ie)); peakpower(ie,2) = 1; end % boolean for exceeds threshold or no
            peakpower(ie,3) = peakF(ie)+frequencies(1)-1; % frequency of blob
            peakpower(ie,4) = peakT(ie)*1000/EEG.srate; % ms of blob
        end
        eventnums(ic,it) = sum(peakpower(:,2)); % number of bursts that trial
        peakpower = peakpower(logical(peakpower(:,2)),:);
        % store
        if eventnums(ic,it) > 0 % if supra-threshold bursts this trial, store ms
            eval(['trialevs.' EEG.chanlocs(ic).labels '.t' num2str(it) ' = [' num2str(peakpower(:,4)') '];']);
        else eval(['trialevs.' EEG.chanlocs(ic).labels '.t' num2str(it) ' = [];']);
        end
        
    end
    
    % store fcz data (from channel identified below)
    if strcmpi(EEG.chanlocs(ic).labels,'FCz'); FCZ = eEEG; end
end

% save 
save('Subject122-betaevs.mat','trialevs','FCZ');

% plot (individual trial with peaks
figure,hold;pcolor(tdata); shading interp; colormap jet; colorbar; scatter(peakT(peakpower(:,2)==1),peakF(peakpower(:,2)==1),'X');
   
%% individual plots
lines = 10; columns = 3;

% load
load('Subject122-betaevs.mat');

% FCZ
% plot individual stop trials
EEG = FCZ;

% figure
h = figure('Color','w','Position',[1 1 600 1200],'Visible','on'); hold;
for it = 1:lines*columns
    subplot(lines,columns,it); pcolor(squeeze(EEG.data(:,:,it))); shading interp
    set(gca,'Ylim',[1 14], 'XLim',[1 700],'Xtick',[1 250 499],'Xticklabel',{'-250','Stim','+250'},'Ytick',[1 14],'Yticklabel',{'15','29'});
    line([250 250],[1 14],'Color','k')
end
