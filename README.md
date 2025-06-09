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
  <img src="https://github.com/user-attachments/assets/39292adf-d765-4afe-9995-3088ff5b2755" width="400">
</div>

*Nota: La cantidad de nodos y la distancia entre los mismos se vario iterando y revisando que hubiera una distribución aceptable (todos las zonas conectados al menos por 1 ruta)*

Con este mapa, se realizó el calculo de la ruta teniendo en cuenta el punto de origen ($P_o = (1.5,0)$) y el punto final ($P_f=(17.33,16)$) obteniendo la siguiente ruta:


<div align="center">
<table border="1">
  <thead>
    <tr>
      <th>X</th>
      <th>Y</th>
    </tr>
  </thead>
  <tbody>
    <tr><td>1.5</td><td>0</td></tr>
    <tr><td>1.1039</td><td>0.022894</td></tr>
    <tr><td>1.6433</td><td>2.8247</td></tr>
    <tr><td>2.0271</td><td>6.5297</td></tr>
    <tr><td>3.1938</td><td>9.2027</td></tr>
    <tr><td>2.9474</td><td>10.026</td></tr>
    <tr><td>3.8093</td><td>11.285</td></tr>
    <tr><td>4.3717</td><td>11.613</td></tr>
    <tr><td>5.7616</td><td>14.657</td></tr>
    <tr><td>8.7926</td><td>14.847</td></tr>
    <tr><td>12.536</td><td>14.786</td></tr>
    <tr><td>17.224</td><td>15.725</td></tr>
    <tr><td>17.33</td><td>16</td></tr>
  </tbody>
</table>
</div>
  
Y el mapa sin inflar con la ruta óptima es 

<div align="center">
  <img src="https://github.com/user-attachments/assets/01afa969-e988-4ee1-b471-a403d60f32c2" width="400">
</div>

El algoritmo PRM usa la función de costo de distancia, al realizar el cálculo de la distancia con la siguiente ecuación

$$\text{Longitud total} = \sum_{i=1}^{N-1} \sqrt{ \sum_{j=1}^{d} \left( x_{i+1,j} - x_{i,j} \right)^2 }$$

Dandonos $28.13$ unidades

### 🔗 Planeación RRT
### ⚙️ Simulación en CoppeliaSim
### 📡 Simulación MATLAB Y COPPELIASIM
## 🦾 Resultados
## 📖 Bibliografia
