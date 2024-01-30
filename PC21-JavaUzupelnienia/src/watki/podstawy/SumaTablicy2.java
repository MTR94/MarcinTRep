package watki.podstawy;

import java.util.Arrays;

public class SumaTablicy2 {

	public static void main(String[] args) {
		final int SIZE = 1000_000;
		int[] t = new int[SIZE];
		Arrays.fill(t, 5);
		System.out.println("Mam tablicę");
		
		// Stwórz dwa wątki, z których każdy obliczy sumę z połowy tej tablicy:
		// od 0 do 499_999 a drugi od 500_000 do 999_999
		// (mogą wypisać swoje wyniki)
		// (to będzie trudniejsze) - potem oblicza jest suma tych dwóch połówek, aby uzyskać sumę całej tablicy
		long wyniki[] = new long[2];
		
		Thread watek1 = new Thread(() -> {
			long suma = 0;
			for(int i = 0; i < t.length / 2; i++) {
				suma += t[i];
			}
			System.out.println(suma);
			wyniki[0] = suma;
		});
		
		Thread watek2 = new Thread(() -> {
			long suma = 0;
			for(int i = t.length / 2; i < t.length; i++) {
				suma += t[i];				
			}
			System.out.println(suma);
			wyniki[1] = suma;
		});
		
		watek1.start();
		watek2.start();
		
		try {
			watek1.join();
			watek2.join();
		} catch (InterruptedException e) {
		}
		
		// gdy oba wątki zakończone, można zsumować tablicę wyników
		long sumaGlobalna = wyniki[0] + wyniki[1];
		System.out.println("Suma ostateczna: " + sumaGlobalna);

	}

}
