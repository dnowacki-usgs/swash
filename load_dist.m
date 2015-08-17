function out = load_dist(filnam, nlay)
% LOAD_DIST Load SWASH model output
%   out = LOAD_DIST(filnam, nlay)
%
% This function loads spatial distributions created by the SWASH numerical
% model (http://swash.sf.net) and saved in .mat (Matlab) files. It can read
% 1D and 2D model outputs with an arbitrary number of vertical levels. The
% purpose of this function is to condense the large number (potentially
% thousands, depending on the output time step) of Matlab variables saved
% in SWASH .mat files into a single vector or matrix.
%
% Inputs: 
%
% filname: Filename, with .mat extension
% nlay: number of vertical layers of the SWASH simulation. This variable is
% optional and, if not specified, a single vertical layer is assumed (i.e.,
% nlay=1).
% 
% Output:
% 
% out: vector or matrix containing 
%
% When using this function, output quantities should be saved in separate
% .mat files (one variable per .mat file). Some variables are inherently
% single-layered, even if the model is run with multiple vertical layers.
% An example is Watlev (water level). The dimension of other variables
% depends on the number of vertical layesrs used in the model run.
% 
% If nlay=1, a vector quantity is read (e.g., Watlev, or Vksik when using a
% single vertical layer). If nlay is greater than 1, a matrix quantitiy
% (e.g., Vksik) is read. Note that layer 1 is the top-most layer; layer N
% is the layer closest to the bed.
%
% Dan Nowacki
% dnowacki@usgs.gov 2015-05

narginchk(1,2);

S = load(filnam);
f = fieldnames(S);

if nargin < 2
    nlay = 1;
end

if ndims(S.(f{1})) == 1
    % 1D runs
    if nlay == 1
        out = nan(length(f), length(S.(f{1})));
        
        for n = 1:length(f)
            out(n,:) = S.(f{n});
        end
    else
        out = nan(length(f)/nlay, length(S.(f{1})), nlay);
        
        p = 1;
        for n = 1:nlay:length(f)-1
            for o = 1:nlay
                out(p,:,o) = S.(f{n+o-1});
            end
            p = p+1;
        end
    end
    
else
    % 2D runs
    if nlay == 1
        out = nan(length(f), size(S.(f{1}),1), size(S.(f{1}),2));
        
        for n = 1:length(f)
            out(n,:,:) = S.(f{n});
        end
    else
        out = nan(length(f)/nlay, size(S.(f{1}), 1), size(S.(f{1}), 2), nlay);
        
        p = 1;
        for n = 1:nlay:length(f)-1
            for o = 1:nlay
                out(p,:,:,o) = S.(f{n+o-1});
            end
            p = p+1;
        end
    end
    
end