package model;

import java.math.BigDecimal;
import java.util.*;

/**
 * Cart - lưu trong Session, quản lý toàn bộ giỏ hàng
 */
/**
 * Cart - lưu trong Session, quản lý toàn bộ giỏ hàng
 */
public class Cart implements java.io.Serializable {
    private Map<Integer, CartItem> items = new LinkedHashMap<>();

    /** Thêm món vào giỏ. Nếu đã có thì tăng số lượng */
    public void add(Product p, int qty) {
        if (items.containsKey(p.getProductID())) {
            CartItem item = items.get(p.getProductID());
            item.setQuantity(item.getQuantity() + qty);
        } else {
            items.put(p.getProductID(),
                new CartItem(p.getProductID(), p.getProductName(),
                             p.getImageURL(), p.getDisplayPrice(), qty));
        }
    }

    /** Cập nhật số lượng. qty <= 0 thì xóa */
    public void update(int productID, int qty) {
        if (qty <= 0) items.remove(productID);
        else if (items.containsKey(productID))
            items.get(productID).setQuantity(qty);
    }

    /** Xóa 1 món khỏi giỏ */
    public void remove(int productID) {
        items.remove(productID);
    }

    /** Xóa toàn bộ giỏ */
    public void clear() {
        items.clear();
    }

    /** Tổng tiền chưa giảm (BigDecimal - dùng trong Java) */
    public BigDecimal getTotal() {
        return items.values().stream()
            .map(CartItem::getSubtotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /** Tổng tiền dạng double - dùng trong JSP EL để so sánh số */
    public double getTotalDouble() {
        return getTotal().doubleValue();
    }

    /** Giảm giá 10% nếu tổng >= 500k */
    public BigDecimal getDiscount() {
        BigDecimal total = getTotal();
        if (total.compareTo(new BigDecimal("500000")) >= 0)
            return total.multiply(new BigDecimal("0.1"));
        return BigDecimal.ZERO;
    }

    public BigDecimal getFinalTotal() {
        return getTotal().subtract(getDiscount());
    }

    public int getTotalItems() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public boolean isEmpty() { return items.isEmpty(); }

    public Collection<CartItem> getItems() { return items.values(); }
}