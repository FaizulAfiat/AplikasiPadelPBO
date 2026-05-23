package com.mycompany.aplikasi_padel_tubes_pbo.model;

public class Pesan {

    private int idPesan;
    private int idChat;
    private int pengirimId;
    private String isiPesan;
    private String waktuKirim;
    private String status;

    public int getIdPesan() {
        return idPesan;
    }

    public void setIdPesan(int idPesan) {
        this.idPesan = idPesan;
    }

    public int getIdChat() {
        return idChat;
    }

    public void setIdChat(int idChat) {
        this.idChat = idChat;
    }

    public int getPengirimId() {
        return pengirimId;
    }

    public void setPengirimId(int pengirimId) {
        this.pengirimId = pengirimId;
    }

    public String getIsiPesan() {
        return isiPesan;
    }

    public void setIsiPesan(String isiPesan) {
        this.isiPesan = isiPesan;
    }

    public String getWaktuKirim() {
        return waktuKirim;
    }

    public void setWaktuKirim(String waktuKirim) {
        this.waktuKirim = waktuKirim;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}