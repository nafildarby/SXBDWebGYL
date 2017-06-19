package com.fh.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5 {

    public static String md5(String str, String encoding) {
        String retValue = "";
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(str.getBytes(encoding));
            byte[] result = md.digest();
            StringBuffer sb = new StringBuffer(32);
            for (int i = 0; i < result.length; i++) {
                int val = result[i] & 0xff;
                //小于15则补0
//		        if (val < 0xf) {
//		            sb.append("0");
//		        }
                sb.append(Integer.toHexString(val));
            }
            retValue = sb.toString();
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return retValue;
    }
	public static void main(String[] args) {
		System.out.println(md5("123","UTF-16LE"));
//		System.out.println(md5("mj1"));
	}


//    public static void main(String[] args) {
//        People g = new People("张三");  // 定义监护人
//        People p1 = new People("儿子1", g);
//        People p2 = p1.clone();  // 儿子2的信息通过拷贝儿子1来的
//        p2.setName("儿子2");
//
//        p1.getGuarder().setName("李四");  // 将儿子1的监护人改为李四
//
//        System.out.println(p1.getName() + "的监控人是：" + p1.getGuarder().getName());
//        System.out.println(p2.getName() + "的监控人是：" + p2.getGuarder().getName());
//    }
//
//
//    static class People implements Cloneable {
//        private String name;
//        private People guarder;  // 监护人
//
//        public String getName() {
//            return name;
//        }
//
//        public void setName(String name) {
//            this.name = name;
//        }
//
//        public People getGuarder() {
//            return guarder;
//        }
//
//        public void setGuarder(People guarder) {
//            this.guarder = guarder;
//        }
//
//        public People(String name) {
//            this.name = name;
//        }
//
//        public People(String name, People guarder) {
//            this.name = name;
//            this.guarder = guarder;
//        }
//
//        // 拷贝实现
//        @Override
//        public People clone() {
//            People p = null;
//            try {
//                p = (People) super.clone();
//                if (guarder != null)
//                    p.guarder = guarder.clone();
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//            return p;
//        }
//    }
}
