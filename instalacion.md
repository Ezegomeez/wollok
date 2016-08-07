---
layout: hyde
---

<img src="/images/installation.jpg" width="100%"/>

# Entorno de Programación

Wollok está implementado dentro de la plataforma Eclipse y necesita instalar una Máquina Virtual de Java 1.8. La misma se puede descargar [aquí](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

Una vez que tengamos la VM de Java, se puede instalar Wollok descomprimiendo el contenido del archivo Zip o Tar.Gz (depende de la plataforma), en cualquier directorio. Te dejamos aquí las versiones ya empaquetadas (que solo hay que descomprimir):

* Linux: 32 / 64 bits
* Mac 32 / 64 bits
* Windows 32 / 64 bits

# Instalación desde el Update Site

Esta opción es para aquellos usuarios avanzados que ya poseen una instalación de Eclipse y desean agregar la posibilidad de trabajar con Wollok, o bien los que ya instalaron Wollok y quieren actualizar su versión a la más reciente.

El Update Site requiere instalarse en una instalación de JDT de Eclipse (o sea que tenga Java). Para hacer eso agregar como Software Update Site:

* [http://update.uqbar.org/wollok/stable](http://update.uqbar.org/wollok/stable) : para acceder a la última versión estable. Esta es la opción **recomendada**.
* [http://update.uqbar.org/wollok/dev](http://update.uqbar.org/wollok/dev) : si querés tener los últimos cambios en proceso (pueden aparecer errores hasta que la versión se estabilice)

# Encontré un Bug... ¿qué hago?

Wollok es una pieza de Software en constante mejora y crecimiento. Como todas las cosas que están en constante evolución es probable que encuentres problemas o se te ocurra una mejora posible que te gustaría ver. 

En caso de encontrar un error, es de mucha ayuda que lo reportes en la página de GitHub de Wollok. Para eso estamos usando un [Issue Tracker](https://github.com/uqbar-project/wollok/issues) (o sea un gestor de errores / incidentes). 

Para hacerlo, algunas recomendaciones:

* Lo más importante es ponerle un título descriptivo que explique el problema lo más claramente posible, y en la descripción indicar los pasos para reproducirlo. Sin esto es muy difícil que podamos solucionar los errores.
* Verás que muchos errores están en inglés, no te sientas intimidado por eso: sentite libre de escribir en castellano si no te sentís cómodo escribiendo en inglés.
* Siempre conviene mirar primero entre los bugs existentes, si alguien no reportó antes lo mismo que estás queriendo reportar.
* Si podés, asociale alguno de estos labels:
	* *Show stopper*: si es un problema que te impide trabajar o sospechás que le va a impedir trabajar a alguien más
	* *Bug*: un error en el sistema que no impide trabajar
	* *Usability*: cuestiones que pueden confundir a los usuarios. Dado que es una herramienta pensada para personas que están dando sus primeros pasos en la programación, presentar una interfaz consistente es muy importante.
	* *Enhancement*: nuevas características que se solicitan
	* *Nice to have*: características deseadas pero menos prioritarias
	* *Question*: dudas, por ejemplo algo que no estamos seguros si es un bug

