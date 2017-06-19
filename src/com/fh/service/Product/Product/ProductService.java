package com.fh.service.Product.Product;

import java.util.List; 

import javax.annotation.Resource; 

import org.springframework.stereotype.Service; 

import com.fh.dao.DaoSupport;  
import com.fh.entity.Page; 
import com.fh.service.BaseService;
import com.fh.util.PageData;


@Service("ProductService")
public class ProductService extends BaseService {
	
	/**
	 * 分页显示商品信息
	 */
	public List<PageData> listProductPage(Page page) throws Exception {
		return  listPageInfo(page, "ProductMapper.pdlistPage");
	}

	/*
	 * 查询全部商品数据
	 */
	public List<PageData> listProduct(Page page) throws Exception {
		return listAllInfo(page,"ProductMapper.pdlist");
	}

	/*
	 * 删除商品数据
	 */
	public void deleteProduct(PageData pd) throws Exception {
		dao.delete("ProductMapper.deleteProduct", pd);		
	}
 
	/*
	 * 保存采购单据
	 */
	public void saveProduct(PageData pd) throws Exception {
		dao.save("ProductMapper.saveProduct", pd);
	}
	
	/**
	 * 通过id查找
	 */
	public PageData findObjectById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("ProductMapper.findObjectById", pd);
	}
	
	/**
	 * 编辑商品信息
	 */
	public void editProduct(PageData pd) throws Exception {
		dao.update("ProductMapper.editProduct", pd);
	}
}
