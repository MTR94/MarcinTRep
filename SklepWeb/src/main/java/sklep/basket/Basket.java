package sklep.basket;


import java.math.BigDecimal;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import sklep.basket.ProductInBasket;
import sklep.model.Product;

public class Basket {
    private final Map<Integer, ProductInBasket> elementy = new HashMap<>();

    public synchronized void addProduct(Product product, int quantity) {
        if(elementy.containsKey(product.getProductId())) {
            // jeśli w słowniku jest już taki element, to tylko zwiększamy ilość
            elementy.get(product.getProductId()).increaseQuantity(quantity);
        } else {
            // jeśli jeszcze nie ma, to tworzymy
            elementy.put(product.getProductId(),
                    new ProductInBasket(product.getProductId(), product.getProductName(), product.getPrice(), quantity));
        }
    }

    public synchronized void addProduct(Product product) {
        // "domyślną ilością, o którą zwiększamy, jest 1"
        addProduct(product, 1);
    }


    public synchronized Collection<ProductInBasket> getElements() {
        return Collections.unmodifiableCollection(elementy.values());
    }

    public synchronized BigDecimal getTotalValue() {
        return getElements().stream()
                .map(ProductInBasket::getValue)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Override
    public synchronized String toString() {
        return "Koszyk o rozmiarze " + getElements().size()
                + " i wartości " + getTotalValue();
    }

}



