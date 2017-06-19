package com.fh.service.system.comboItem;

import java.util.List; 

import javax.annotation.Resource; 

import org.springframework.stereotype.Service; 

import com.fh.dao.DaoSupport;  
import com.fh.entity.Page; 
import com.fh.entity.Product.Category;
import com.fh.entity.system.ComboItem;
import com.fh.entity.system.Role;
import com.fh.util.PageData;


@Service("ComboItemService")
public class ComboItemService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	public List<ComboItem> listAllcomboItem() throws Exception {
		return (List<ComboItem>) dao.findForList("ComboItemMapper.listAllcomboItem", null);
	}
	
}
