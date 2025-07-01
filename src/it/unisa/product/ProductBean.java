package it.unisa.product;

public class ProductBean {
	int idProdotto;
	String nome;
	String categoria;
	String descrizione;
	boolean stato;
	String lingua;
	int iva;
	float prezzo;
	int stock;
	String linkAccesso;
	String linkImg;
	
	public ProductBean(){
		idProdotto = -1;
		nome = "";
		categoria = "";
		descrizione = "";
		stato = false;
		lingua = "";
		iva = 0;
		prezzo = 0;
		stock = 0;
		linkAccesso = "";
		linkImg = "";
	}
	
	public int getIdProdotto() {
		return idProdotto;
	}
	
	public void setIdProdotto(int id) {
		this.idProdotto = id;
	}
	public String getNome() {
		return nome;
	}
	
	public void setNome(String n) {
		this.nome = n;
	}
	
	public String getDescrizione() {
		return descrizione;
	}
	
	public void setDescrizione(String d) {
		this.descrizione = d;
	}
	
	public boolean getStato() {
		return stato;
	}
	
	public void setStato (boolean s ) {
		this.stato = s;
	}
	
	public String getCategoria() {
		return categoria;
	}

	public void setCategoria(String categoria) {
		this.categoria = categoria;
	}

	public String getLingua() {
		return lingua;
	}

	public void setLingua(String lingua) {
		this.lingua = lingua;
	}

	public int getIva() {
		return iva;
	}

	public void setIva(int iva) {
		this.iva = iva;
	}

	public float getPrezzo() {
		return prezzo;
	}

	public void setPrezzo(float prezzo) {
		this.prezzo = prezzo;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public String getLinkAccesso() {
		return linkAccesso;
	}

	public void setLinkAccesso(String linkAccesso) {
		this.linkAccesso = linkAccesso;
	}

	public String getLinkImg() {
		return linkImg;
	}

	public void setlinkImg(String linkImg) {
		this.linkImg = linkImg;
	}
}
