# 🚗 Tarea - Navegación
## 🪶 Autores
* Andres Camilo Torres Cajamarca (antorresca@unal.edu.co)
* Juan Camilo Gomez Robayo (juagomezro@unal.edu.co)
## 🎢 Procedimiento
### 🤖 Modelo del robot
Para el modelo cinemático, se tiene que el robot tiene 4 ruedas fijas motorizadas:

Con lo cual, cada rueda puede girar a una velocidad diferente ($\phi_1,\phi_2,\phi_3,\phi_4$), útil para terrenos irregulares; sin embargo, en este caso, el terreno es plano, por ello, se puede simplificar el modelo haciendo que ($\phi_1=\phi_4=\phi_l$ y $\phi_2=\phi_3=\phi_r$) haciendo que el modelo cinematico se simplifique a:

*Nota: La rueda esferica se colocó simplemente para mantener la condición de estabilidad.*

Tomando esto, el robot *Summit XL* de *Robornik* puede actuar como un robot diferencial y se pueden emplear lo siguiente:

$$ \begin{bmatrix}
\frac{r}{2} & \frac{r}{2} \\
0 & 0 \\
\frac{r}{l} & \frac{r}{l} \\
\end{bmatrix} \cdot  \begin{bmatrix}
\phi_r \\
\phi_l \\
\end{bmatrix} =  \begin{bmatrix}
\dot{x} \\
\dot{y} \\
\omega \\
\end{bmatrix}$$

### 🗺️ Mapas
Al importar el archivo de datos de ocupación, se obtuvo el siguiente mapa de ocupación binaria

<div align="center">
  <img src="https://github.com/user-attachments/assets/289e4a59-f5fa-4b78-86e3-625a67d4018b" width="400">
</div>

En el mapa tambien se ubicó en rojo el punto de origen $P_o = (1.5,0)$ y en azul el punto final $P_f=(17.33,16)$. Para realizar el mapa inflado, se tomó la distancia desde la rueda delantera derecha y la delantera izquierda del robot en *CoppeliaSim* dandonos como valor $0.46$ m, con ello se determinó que el inflado del mapa sería de $\frac{0.5}{2}=0.25$ m asegurando así un margen de seguridad con las paredes:

<div align="center">
  <img src="https://github.com/user-attachments/assets/c5dd82c2-8991-44c5-bb31-68993fdaa1e9" width="400">
</div>

### 🪢 Planeación PRM

Para la planeación PRM, se usó la siguiente sección de codigo

```matlab
mapPRM = mobileRobotPRM; %Crear objeto para Planificacion PRM
mapPRM.Map = mapaInflado; %Asignacion de mapa
mapPRM.NumNodes = 250; %Cantidad de nodos totales
mapPRM.ConnectionDistance = 5; %Distancia de conexión entre nodos
```

Con ello, se crea el mapa para hacer la planeación PRM definiendo el mapa, la cantidad de nodos ($250$) y la distancia máxima de conexion entre nodos ($5$m). El mapa que se obtuvo es el siguiente:

<div align="center">
  <img src="https://github.com/user-attachments/assets/a37a3e08-9360-4cb6-8b6c-5004bfbf22b2" width="400">
</div>

*Nota: La cantidad de nodos y la distancia entre los mismos se vario iterando y revisando que hubiera una distribución aceptable (todos las zonas conectados al menos por 1 ruta)*

Con este mapa, se realizó el calculo de la ruta teniendo en cuenta el punto de origen ($P_o = (1.5,0)$) y el punto final ($P_f=(17.33,16)$) obteniendo la siguiente ruta:

<div align="center">
<table border="1" cellpadding="5" cellspacing="0">
  <thead>
    <tr>
      <th>X</th>
      <th>Y</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>1.5</td><td>0</td></tr>
    <tr><td>1.9332</td><td>0.54393</td></tr>
    <tr><td>2.0276</td><td>2.1989</td></tr>
    <tr><td>2.1132</td><td>5.636</td></tr>
    <tr><td>3.051</td><td>8.468</td></tr>
    <tr><td>3.2082</td><td>11.151</td></tr>
    <tr><td>5.1399</td><td>12.597</td></tr>
    <tr><td>5.4115</td><td>15.363</td></tr>
    <tr><td>6.2514</td><td>15.041</td></tr>
    <tr><td>10.489</td><td>14.926</td></tr>
    <tr><td>13.062</td><td>15.17</td></tr>
    <tr><td>17.066</td><td>15.609</td></tr>
    <tr><td>17.33</td><td>16</td></tr>
  </tbody>
</table>
</div>
  
Y el mapa sin inflar con la ruta óptima es 

<div align="center">
  <img src="https://github.com/user-attachments/assets/b0133819-ed56-4963-8038-3c23f9150d62" width="400">
</div>

El algoritmo PRM usa la función de costo de distancia, al realizar el cálculo de la distancia con la siguiente ecuación

$$\text{Longitud total} = \sum_{i=1}^{N-1} \sqrt{ \sum_{j=1}^{d} \left( x_{i+1,j} - x_{i,j} \right)^2 }$$

Dandonos $28.88$ unidades

### 🔗 Planeación RRT

Para la planeación de la ruta usando el algoritmo RRT (Rapidly Random Tree), se utilizó la función planner de Matlab, y se configuró de la siguiente manera:
```matlab
bounds = [mapa.XWorldLimits; mapa.YWorldLimits; [-pi pi]];
ss = stateSpaceDubins(bounds);
ss.MinTurningRadius = 0.5;
```
De acuerdo a las dimensiones del robot se asigna un valor de radio de giro de 50 cm, y se toman los límites del mapa como referencia
Para la configuración del planeador se progrmaron los siguientes valores:
```matlab
stateValidator = validatorOccupancyMap(ss); 
stateValidator.Map = mapaInflado;
stateValidator.ValidationDistance = 0.4;
planner = plannerRRT(ss,stateValidator);
planner.MaxConnectionDistance = 1;
planner.MaxIterations = 2000;
```
Se asigna un valor de 40 cm a la distancoa de validación y 1 metro a la máxima distancia de conexión entre puntos, el mapa de referencia es nuestro mapa inflado y los límites anteriormente programados, con 2.000 iteraciones es suficiente para que encuentre la ruta del origen al punto objetivo.
Las trayectorias realizadas se muestran en la siguiente imagen:

<div align="center">
  <img src=https://github.com/user-attachments/assets/b1738b95-2708-461e-9544-22c9ab0c2092>
</div>
En la tabla [Tabla puntos RRT.xls](Tabla puntos RRT.xls) se almacenan los 300 puntos o nodos obtenidos del algoritno de busqueda de la trayectoria.
Procedemos con la interpolación de los nodos para encontrar la ruta óptima

``` matlab
interpolate(pthObj, 300)
```
La ruta obtenida es la siguiente:
<div align="center">
  <img src=https://github.com/user-attachments/assets/6b2e1e24-eeb9-4287-8415-de4c4b18bbbb>
</div>


### ⚙️ Simulación en CoppeliaSim

Para la simulación, se siguieron los pasos descritos en la guia y se obtuvo la escena [tarea_navegacion.ttt](tarea_navegacion.ttt)

<div align="center">
  <img src="https://github.com/user-attachments/assets/3938b8fb-7999-40ec-bd53-355292b55f9f" width="400">
</div>

### 📡 Simulación MATLAB Y COPPELIASIM

Para realizar la simulacion en MatLab, se empleó el archivo [comunicacion_coppelia.m](comunicacion/comunicacion_coppelia.m) en el cual, el script ubica el robot en la posición inicial, y sigue la trayectoria PRM con el controlador Pure Pursuit y la cinematica desarrollada en la sección [Modelo del robot](#-modelo-del-robot).

<div align="center">
  <video src="https://github.com/user-attachments/assets/99522c0f-569f-403e-af17-d71b48e3c42d" width="400">
</div>

## 🦾 Resultados

## 📖 Bibliografia

* «controllerPurePursuit - Create controller to follow set of waypoints - MATLAB». Disponible en: https://la.mathworks.com/help/nav/ref/controllerpurepursuit-system-object.html
* «Probabilistic Roadmaps (PRM) - MATLAB & Simulink». Disponible en: https://la.mathworks.com/help/robotics/ug/probabilistic-roadmaps-prm.html?requestedDomain=
* «Plan Mobile Robot Paths Using RRT - MATLAB & Simulink». Disponible en: https://www.mathworks.com/help/nav/ug/plan-mobile-robot-paths-using-rrt.html
