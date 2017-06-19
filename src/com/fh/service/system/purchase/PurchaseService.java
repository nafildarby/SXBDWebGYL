package com.fh.service.system.purchase;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fh.dao.DaoSupport;
import com.fh.entity.Page;
import com.fh.entity.system.User;
import com.fh.util.PageData;

@Service("PurchaseService")
public class PurchaseService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	// ======================================================================================

	/*
	 * 通过id获取数据
	 */
	public PageData findByPid(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PurchaseMapper.findByPid", pd);
	}

	/*
	 * 保存采购单据
	 */
	public void saveP(PageData pd) throws Exception {
		dao.save("PurchaseMapper.saveP", pd);
	}

	/*
	 * 修改采购单据
	 */
	public void editP(PageData pd) throws Exception {
		dao.update("PurchaseMapper.editP", pd);
	}

	/*
	 * 删除采购单据
	 */
	public void deleteP(PageData pd) throws Exception {
		dao.delete("PurchaseMapper.deleteP", pd);
	}
	
	/*
	 * 查询采购单据
	 */
	public List<PageData> listPdPagePurchase(Page page) throws Exception {
		return (List<PageData>) dao.findForList("PurchaseMapper.purchaselistPage",
				page);
	}
	
	public List<PageData> PurchaseList() throws Exception {
		return (List<PageData>) dao.findForList("PurchaseMapper.PurchaseList",null);
	}
}
