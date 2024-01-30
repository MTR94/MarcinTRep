package serwlety.beans;

public class KalkulatorBean {
    private int arg1, arg2;
    private String operacja;

    public int getArg1() {
        return arg1;
    }

    public void setArg1(int arg1) {
        this.arg1 = arg1;
    }

    public int getArg2() {
        return arg2;
    }

    public void setArg2(int arg2) {
        this.arg2 = arg2;
    }

    public String getOperacja() {
        return operacja;
    }

    public void setOperacja(String operacja) {
        this.operacja = operacja;
    }

    public int getWynik() {
        switch(operacja) {
            case "+" : return arg1 + arg2;
            case "-" : return arg1 - arg2;
            case "*" : return arg1 * arg2;
            case "/" : return arg1 / arg2;
            default : return 0;
        }
    }

}


