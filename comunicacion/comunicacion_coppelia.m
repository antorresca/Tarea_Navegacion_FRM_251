sim = remApi('remoteApi'); % crear objeto Remote API
sim.simxFinish(-1); % cerrar conexiones previas

clientID = sim.simxStart('127.0.0.1',19997,true,true,5000,5); % conectar

if clientID > -1
    disp('✅ Conexión exitosa con CoppeliaSim');

    % Handles de ruedas
    [~, wheels.fl] = sim.simxGetObjectHandle(clientID, '/RobotnikSummitXL/front_left_wheel', sim.simx_opmode_blocking);
    [~, wheels.bl] = sim.simxGetObjectHandle(clientID, '/RobotnikSummitXL/back_left_wheel', sim.simx_opmode_blocking);
    [~, wheels.fr] = sim.simxGetObjectHandle(clientID, '/RobotnikSummitXL/front_right_wheel', sim.simx_opmode_blocking);
    [~, wheels.br] = sim.simxGetObjectHandle(clientID, '/RobotnikSummitXL/back_right_wheel', sim.simx_opmode_blocking);

    % Handle del cuerpo del robot
    [~, robotHandle] = sim.simxGetObjectHandle(clientID, '/RobotnikSummitXL', sim.simx_opmode_blocking);

    % ====== Establecer pose inicial ======
    initialPosition = [1.5, 0, 1.2]; % x, y, z (altura suele estar en 0.1 m)
    initialOrientationEuler = [0, 0, pi/2]; % roll, pitch, yaw (orientación)

    sim.simxSetObjectPosition(clientID, robotHandle, -1, initialPosition, sim.simx_opmode_blocking);
    sim.simxSetObjectOrientation(clientID, robotHandle, -1, initialOrientationEuler, sim.simx_opmode_blocking);
    sim.simxSetJointTargetVelocity(clientID, wheels.fl, 0, sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, wheels.bl, 0, sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, wheels.fr, 0, sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, wheels.br, 0, sim.simx_opmode_oneshot);
    pause(2); % esperar que se aplique la pose

    % ====== Controlador PurePursuit ======
    % Definir path (waypoints)
    path = [1.5000     ,    0;
    1.9332  ,  0.5439;
    2.0276  ,  2.1989;
    2.1132  ,  5.6360;
    3.0510  ,  8.4680;
    3.2082  , 11.1508;
    5.1399  , 12.5970;
    5.4115  , 15.3630;
    6.2514  , 15.0408;
   10.4892  , 14.9262;
   13.0621  , 15.1703;
   17.0658  , 15.6092;
   17.3300  , 16.0000]; % Ejemplo, reemplaza con tus waypoints

    controller = controllerPurePursuit;
    controller.Waypoints = path;
    controller.LookaheadDistance = 1;
    controller.DesiredLinearVelocity = 0.5;
    controller.MaxAngularVelocity = 2;

    % Cinemática diferencial
    d = 0.23367;
    r = d/2;
    l = 2 * 0.23397;
    A = [[r/2 r/2]; [0 0]; [r/(2*l) -r/(2*l)]];

    % Inicializar streaming de pose
    sim.simxGetObjectPosition(clientID, robotHandle, -1, sim.simx_opmode_streaming);
    sim.simxGetObjectOrientation(clientID, robotHandle, -1, sim.simx_opmode_streaming);
    pause(0.1);

    goalRadius = 0.2;
    stop = false;

    while ~stop
        [~, pos] = sim.simxGetObjectPosition(clientID, robotHandle, -1, sim.simx_opmode_buffer);
        [~, ori] = sim.simxGetObjectOrientation(clientID, robotHandle, -1, sim.simx_opmode_buffer);
        theta = ori(3)+pi;

        robotPose = [pos(1), pos(2), theta];

        [v, w] = controller(robotPose);
        distanceToGoal = norm(robotPose(1:2) - path(end, :));

        if distanceToGoal < goalRadius
            disp('🏁 Objetivo alcanzado');
            break;
        end

        % Velocidades a ruedas
        v_robot = [v; 0; w];
        wheelSpeeds = pinv(A) * v_robot;

        sim.simxSetJointTargetVelocity(clientID, wheels.fl, wheelSpeeds(1), sim.simx_opmode_oneshot);
        sim.simxSetJointTargetVelocity(clientID, wheels.bl, wheelSpeeds(1), sim.simx_opmode_oneshot);
        sim.simxSetJointTargetVelocity(clientID, wheels.fr, -wheelSpeeds(2), sim.simx_opmode_oneshot);
        sim.simxSetJointTargetVelocity(clientID, wheels.br, -wheelSpeeds(2), sim.simx_opmode_oneshot);

        pause(0.05);
    end

    % Detener robot al finalizar
    sim.simxSetJointTargetVelocity(clientID, wheels.fl, 0, sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, wheels.bl, 0, sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, wheels.fr, 0, sim.simx_opmode_oneshot);
    sim.simxSetJointTargetVelocity(clientID, wheels.br, 0, sim.simx_opmode_oneshot);
    pause(1);

    sim.simxFinish(clientID);
else
    disp('❌ Fallo en la conexión');
end

sim.delete(); % destruir objeto Remote API
