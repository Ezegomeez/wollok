---
layout: hyde
---

# Guía 1 - Ejercicios con objetos


## Ejercicio 1 – Aves y entrenadores

### Parte 1 - Pepita come y vuela

Definir un objeto 'pepita" que entienda los mensajes:

* energia, que devuelve su energía actual
* volar(metros), que consume energia a razón de 4 calorías por metro volado
* comer(comida) que aumenta la energía de pepita en tantas calorías como tenga la comida.

Para el estado interno de pepita, utilizar una única variable llamada energia, que arranque en 100 calorías y contenga todo el tiempo la energía actual de pepita.

Además necesitamos diferentes objetos que pepita pueda comer:

* alpiste, que otorga 5 calorías
* manzana, que otorga 80 calorías
* hamburguesa, que otorga 800 calorías. 

### Parte 2 - El picaflor pepe

El ornitólogo tiene otra ave: un picaflor llamado pepe. Pepe sabe hacer las mismas cosas que pepita, pero su consumo de energía es distinto:

<div class="sidenote">
<h3>Tip: Máximos y mínimos</h3>
<p>
Los números entienden dos mensajes útiles para calcular máximos y mínimos:
3.max(10) devuelve 10
3.min(10) devuelve 3
</p>
</div>

* Pepe es incansable, entonces al volar siempre consume lo mismo: 10 calorías. No importa cuantos metros vuele.
* Pepe es pequeño, no puede comer mucho... cualquier cosa que coma le da como máximo 10 calorías. 

### Parte 3 - Pepona, la gaviota gordinflona

Y el ornitólogo no descansa y nos pide que le modelemos un ave más, su gaviota pepona.

Pepona tiene tendencia a engordar... y también es un poco vaga. Por eso, cada vez que vuela se cansa un poco más que la vez anterior. Al arrancar consume lo mismo que pepita: "cuatro calorías por metro", pero cada vez que vuela ese número se duplica.

Pero no todo es tan dramático, cuando logra comer algo su "consumo por metro" vuelve al valor original: 4.