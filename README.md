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

En el mapa tambien se ubicó en rojo el punto de origen $P_o = (1.5,0)$ y en azul el punto final $P_f=(17.33,16)$. Para realizar el mapa inflado, se tomó la distancia desde la rueda delantera derecha y la trasera izquierda del robot en *CoppeliaSim* dandonos como valor $0.46$ m, con ello se determinó que el inflado del mapa sería de $0.5$ m asegurando así un margen de seguridad con las paredes:

<div align="center">
  <img src="https://github.com/user-attachments/assets/c5dd82c2-8991-44c5-bb31-68993fdaa1e9" width="400">
</div>


### 🪢 Planeación PRM
### 🔗 Planeación RRT
### ⚙️ Simulación en CoppeliaSim
### 📡 Simulación MATLAB Y COPPELIASIM
## 🦾 Resultados
## 📖 Bibliografia
