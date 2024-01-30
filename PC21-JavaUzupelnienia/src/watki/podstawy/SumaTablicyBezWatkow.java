package watki.podstawy;

import java.util.Arrays;

public class SumaTablicyBezWatkow {

	public static void main(String[] args) {
		System.out.println("Startujemy");
		final int SIZE = 500_000_000;
		int[] t = new int[SIZE];
		Arrays.fill(t, 5);
		System.out.println("Mam tablicę");

		long p = System.nanoTime();
		long suma = 0;
		for (int i = 0; i < t.length; i++) {
			suma += t[i];
		}
		long k = System.nanoTime();

		System.out.printf("Suma ostateczna: %s\n", suma);
		System.out.printf("Czas działania: %.6f\n", (k - p) * 1e-9);
	}

}
