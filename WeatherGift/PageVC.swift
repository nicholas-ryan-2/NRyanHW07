//
//  PageVC.swift
//  WeatherGift
//
//  Created by Nick on 3/20/17.
//  Copyright © 2017 Nick Ryan. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {
    
    var currentPage: Int = 0
    var locationsArray = [WeatherLocation]()
    var pageControl: UIPageControl!
    var listButton: UIButton!
    let barButtonWidth: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        var newLocation = WeatherLocation()
        newLocation.name = "Unknown Weather Location"
        locationsArray.append(newLocation)
        configurePageControl()
        configureListButton()
        setViewControllers([createDetailVC(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }

    func configureListButton() {
        let barButtonHeight = barButtonWidth
        listButton = UIButton(frame: CGRect(x: view.frame.width - barButtonWidth, y: view.frame.height - barButtonHeight, width: barButtonWidth, height: barButtonHeight))
        listButton.setBackgroundImage(UIImage(named: "image0"), for: .normal)
        listButton.setBackgroundImage(UIImage(named: "image1"), for: .highlighted)
        listButton.addTarget(self, action: #selector(segueToListVC), for: .touchUpInside)
        view.addSubview(listButton)
    }
    
    func createDetailVC(forPage page: Int) -> DetailVCViewController {
        currentPage = min(max(0, page), locationsArray.count - 1)
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVCViewController
        detailVC.locationsArray = locationsArray
        detailVC.currentPage = currentPage
        return detailVC
    }
    func segueToListVC(sender: UIButton!) {
        performSegue(withIdentifier: "ToListVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToListVC" {
            let controller = segue.destination as! ListVC
            controller.locationsArray = locationsArray
            controller.currentPage = currentPage
        }
    }
    
    func configurePageControl() {
        let pageControlHeight: CGFloat = barButtonWidth
        let pageControlWidth: CGFloat = view.frame.width - barButtonWidth * 2
        pageControl = UIPageControl(frame: CGRect(x: (view.frame.width - pageControlWidth) / 2, y: (view.frame.height - pageControlHeight) / 2, width: pageControlWidth, height: pageControlHeight))
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        view.addSubview(pageControl)
    }
    
    @IBAction func unwindFromListVC(sender: UIStoryboardSegue) {
        pageControl.numberOfPages = locationsArray.count
        pageControl.currentPage = currentPage
        setViewControllers([createDetailVC(forPage: currentPage)], direction: .forward, animated: false, completion: nil)
        
        
    }
}
extension PageVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVCViewController {
            if currentViewController.currentPage < locationsArray.count - 1 {
                return createDetailVC(forPage: currentViewController.currentPage + 1)
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? DetailVCViewController {
            if currentViewController.currentPage > 0 {
                return createDetailVC(forPage: currentViewController.currentPage - 1)
            }
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?[0] as? DetailVCViewController {
            pageControl.currentPage = currentViewController.currentPage
        }
    }
}
