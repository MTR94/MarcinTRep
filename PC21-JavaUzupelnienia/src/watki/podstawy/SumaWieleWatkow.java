package watki.podstawy;

import java.util.Arrays;

public class SumaWieleWatkow {
	static long sumaPrzedzialu(int[] tablica, int lewo, int prawo) {
		// liczy sumę elementów od lewo włącznie do prawy wyłączając
		long suma = 0;
		for(int i = lewo; i < prawo; i++) {
			suma += tablica[i];
		}
		return suma;
	}

	
	public static long sumaWieleWatkow(int[] tablica, int ileWatkow) {
		long[] podsumy = new long[ileWatkow];
		
		Thread[] watki = new Thread[ileWatkow];
		for(int nr = 0; nr < ileWatkow; nr++) {
			final int numer = nr;
			final int lewy = (int)((long)nr * tablica.length / ileWatkow);
			final int prawy = (int)((long)(nr+1) * tablica.length / ileWatkow);
			watki[nr] = new Thread(() -> {
				long sumaCzesciowa = sumaPrzedzialu(tablica, lewy, prawy);
				podsumy[numer] = sumaCzesciowa;
			});
		}
		
		for(int nr = 0; nr < ileWatkow; nr++) {
			watki[nr].start();
		}
		
		// czekamy, aż wątki się zakończą i dodajemy ich podsumy do sumy ogólnej
		long suma = 0;
		try {
			for(int nr = 0; nr < ileWatkow; nr++) {
				watki[nr].join();
				suma += podsumy[nr];
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		return suma;
	}
	
	public static void main(String[] args) {
		final int SIZE = 500_000_000;
		int[] t = new int[SIZE];
		Arrays.fill(t, 5);
		
		System.out.println("Suma 8 wątków");
		long p = System.nanoTime();
		long suma = sumaWieleWatkow(t, 8);
		long k = System.nanoTime();
		
		System.out.printf("Suma ostateczna: %s\n", suma);
		System.out.printf("Czas działania: %.6f\n", (k-p)*1e-9);

	}

}
