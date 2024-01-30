package watki.podstawy;

import java.util.Arrays;
import java.util.concurrent.atomic.AtomicLong;

public class SumaTablicyAtomic {

	public static void main(String[] args) {
		System.out.println("Startujemy");
		final int SIZE = 500_000_000;
		int[] t = new int[SIZE];
		Arrays.fill(t, 5);
		System.out.println("Mam tablicę");
		
		AtomicLong sumaGlobalna = new AtomicLong();
		
		Thread watek1 = new Thread(() -> {
			long suma = 0;
			for(int i = 0; i < t.length / 2; i++) {
				suma += t[i];
			}
			sumaGlobalna.addAndGet(suma);
		});
		
		Thread watek2 = new Thread(() -> {
			long suma = 0;
			for(int i = t.length / 2; i < t.length; i++) {
				suma += t[i];				
			}
			sumaGlobalna.addAndGet(suma);
		});
		
		long p = System.nanoTime();
		watek1.start();
		watek2.start();
		
		try {
			watek1.join();
			watek2.join();
		} catch (InterruptedException e) {
		}
		long k = System.nanoTime();
		
		System.out.printf("Suma ostateczna: %s\n", sumaGlobalna);
		System.out.printf("Czas działania: %.6f\n", (k-p)*1e-9);

	}

}
