	class Ave {
		var energia = 100

		method energia( ) = energia
		method setEnergia(newEnergia) {
			energia = newEnergia
		}
	}
	class Golondrina inherits Ave {
		method volar(kms) {
			this.setEnergia(this.energia() - kms) // Uso métodos de la superclase
		}
	}
