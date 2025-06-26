package it.unisa.order;

import java.sql.Date;
import java.sql.Timestamp;

public class FatturaBean {
	
    private static final long serialVersionUID = 1L;

    private int idFattura;
    private int idUtente;
    private Timestamp dataOrdine;
    private double prezzoTotale;

    public FatturaBean() {
        // Costruttore vuoto richiesto per il bean
    }

    public int getIdFattura() {
        return idFattura;
    }

    public void setIdFattura(int idFattura) {
        this.idFattura = idFattura;
    }

    public int getIdUtente() {
        return idUtente;
    }

    public void setIdUtente(int idUtente) {
        this.idUtente = idUtente;
    }

    public Timestamp getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(Timestamp timestamp) {
        this.dataOrdine = timestamp;
    }

    public double getPrezzoTotale() {
        return prezzoTotale;
    }

    public void setPrezzoTotale(double prezzoTotale) {
        this.prezzoTotale = prezzoTotale;
    }

    @Override
    public String toString() {
        return "FatturaBean [idFattura=" + idFattura + ", idUtente=" + idUtente + 
               ", dataOrdine=" + dataOrdine + ", prezzoTotale=" + prezzoTotale + "]";
    }

}
