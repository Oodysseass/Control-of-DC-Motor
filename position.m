function x1 = position(r, a)
    close all
    % initialization
    V_7805 = 5.48;
    Vref_arduino = 5;
    analogWrite(a,6,0);
    analogWrite(a,9,0);
    positionData = [];
    velocityData = [];
    uData = [];
    timeData = [];
    t = 0;
    
    
    tic             % start time
    while(t < 5)  
        velocity = analogRead(a, 3);
        position = analogRead(a, 5);
        x1 = 3 * Vref_arduino * position / 1023;                % position
        x2 = 2 * (2 * velocity * Vref_arduino / 1023 - V_7805); % velocity
        % r = 5 + 2 * sin(3 * toc);
        u = 8 *(r - x1) - 2 * x2;                      % controller
        if u > 0
            analogWrite(a, 6, 0);
            analogWrite(a, 9, min(round(u / 2 * 255 / Vref_arduino), 255));
        else
            analogWrite(a, 9, 0);
            analogWrite(a, 6, min(round(-u / 2 * 255 / Vref_arduino), 255));
        end
        t = toc;
        timeData = [timeData t];
        positionData = [positionData x1];
        velocityData = [velocityData x2];
        uData = [uData u];
    end
    analogWrite(a,6,0);
    analogWrite(a,9,0);
    figure(1);clf;
    subplot(3,1,1)
    plot(timeData, positionData);
    title('position')
    subplot(3,1,2)
    plot(timeData, velocityData);
    title('velocity')
    subplot(3,1,3)
    plot(timeData, uData);
    title('controller')
end