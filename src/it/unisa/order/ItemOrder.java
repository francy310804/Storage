package it.unisa.order;

import it.unisa.product.ProductBean;

/* Questa classe rappresenta la voce del nostro carrello
che è formata dal productBean + la relativa quantità*/

public class ItemOrder {
	private ProductBean item;
	private int numItems;
	private int iva;
	private String linkAccesso;
	
	public ItemOrder() {
		
	}
	
	public ItemOrder(ProductBean item) {
	    setItem(item);
	    setNumItems(1);
	    setIva(item.getIva());
	}
	
	public int getItemID() {
		return(getItem().getIdProdotto());
	}
	
	public String getCategoria() {
		return(getItem().getCategoria());	
	}
	
	public void setlinkAccesso(String l) {
		this.linkAccesso = l;
		
	}
	
	public String getlinkAccesso() {	
		return this.linkAccesso;
	}
		
	
	public ProductBean getItem() {
		return(item);
	}
	
	protected void setItem(ProductBean item) {
		this.item = item;
	}
	
	public String getLinkImg() {
		return(getItem().getLinkImg());
	}
	
	public String getNome() {
		return(getItem().getNome());
	}

	public double getUnitCost() {
		return(getItem().getPrezzo());
	}
		  
	public int getNumItems() {
		return(numItems);
	}

	public void setNumItems(int n) {
		this.numItems = n;
	}

	public void incrementNumItems() {
		setNumItems(getNumItems() + 1);
	}

	public void cancelOrder() {
		setNumItems(0);
	}

	public double getTotalCost() {
		return(getNumItems() * getUnitCost());
	}
	
	public void setIva(int iva) {
		this.iva = iva;
	}
	
	public int getIva(){
		return(this.iva);
	}
}
