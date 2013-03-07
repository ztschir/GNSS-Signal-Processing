% computeIonosphericDelay ---- Compute the ionospheric delay experienced by a
% transionospheric GNSS signal as it propagates from a GNSS SV to the antenna
% of a terrestrial GNSS receiver.
%
% INPUTS
%
% ionoData ------- Structure containing a parameterization of the
%                  ionosphere that is valid at time tGPS. The structure is
%                  defined differently depending on what ionospheric model
%                  is selected:
%
%                  broadcast --- For the broadcast (Klobuchar) model, ionoData
%                  is a structure containing the following fields:
%
%                  alpha0 ... alpha3 -- power series expansion coefficients
%                  for amplitude of ionospheric TEC
%
%                  beta0 .. beta3 -- power series expansion coefficients for
%                  period of ionospheric plasma density cycle
%
%
%                  Other models TBD ...
%
% fc ------------- Carrier frequency of the GNSS signal, in Hz.
%
% rAntRx --------- A 3-by-1 vector representing the receiver antenna position
%                  at the time of receipt of the signal, expressed in meters
%                  in the ECEF reference frame.
%
% rSvTx ---------- A 3-by-1 vector representing the space vehicle antenna
%                  position at the time of transmission of the signal,
%                  expressed in meters in the ECEF reference frame.
%
% tGPS ----------- A structure containing the true GPS time of receipt of
%                  the signal. The structure has the following fields:
%
%                  week -- unambiguous GPS week number
%
%                  seconds -- seconds (including fractional seconds) of the
%                  GPS week
%
% model ---------- A string identifying the model to be used in the
%                  computation of the ionospheric delay:
%
%                  broadcast --- The broadcast (Klobuchar) model.
%
%                  Other models TBD ...
%
% OUTPUTS
%
% delTauG -------- Modeled scalar excess group ionospheric delay experienced
%                  by the transionospheric GNSS signal.

function [delTauG] = computeIonosphericDelay(ionoData,fc,rAntRx,rSvTx,tGPS,model)

if (model == 'broadcast')
    
    per = 0.0;
    amp = 0.0;

    user = ecef2lla(rAntRx);
    sv = ecef2lla(rSvTx);
    userLat = user(1);
    userLong = user(2);
    userAlt = user(3);
    svLat = sv(1);
    svLong = sv(2);
    svAlt = sv(3);
  
    [elevationAng, slantRange, azimuthAng] = elevation(userLat, userLong, userAlt, svLat, svLong, svAlt);

    elevAngRad = deg2rad(elevationAng)/pi;
    azimAngRad = deg2rad(azimuthAng);
    userLatRad = deg2rad(userLat)/pi;
    userLongRad = deg2rad(userLong)/pi;    
    centerAng = (0.0137/((elevAngRad) + 0.11)) - 0.022;
    geodIonoInterLat = (userLatRad) + centerAng * cos(azimAngRad);

    if (geodIonoInterLat > 0.416) 
        geodIonoInterLat = 0.416;
    elseif (geodIonoInterLat < -0.416)
        geodIonoInterLat = -0.416;
    end

    geodIonoInterLong = (userLongRad) + (centerAng * sin(azimAngRad))/cos(geodIonoInterLat * pi);
    geomIonoInterLat = geodIonoInterLat + 0.064 * cos((geodIonoInterLong - 1.617) * pi);
    obliquity = 1.0 + (16.0*((.53 - (elevAngRad))^3));
    nighttimeDelay = 5e-9;
    
    for (n = 0:3)
        amp = amp + (ionoData(1,(n+1)) * geomIonoInterLat^n);
        if (amp < 0.0)
            amp = 0.0;
        end
        per = per + (ionoData(2,(n+1)) * geomIonoInterLat^n);
        if (per < 72000.0)
            per = 72000.0;
        end
    end   
    
    t = ((4.32e4) * geodIonoInterLong) + tGPS(2);
    while (t >= 86400.0)
        t = t - 86400.0;
    end
    while (t < 0.0)
        t = t + 86400.0;
    end

    x = (2*pi*(t-50400.0))/per;

    if (abs(x) < 1.57);
        Tiono = obliquity * (nighttimeDelay + amp*(1-((x^2)/2)+((x^4)/24))); 
    else
        Tiono = obliquity * nighttimeDelay;
    end
        
    delTauG = Tiono;
end