using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["time"] = DateTime.Now.AddSeconds(95);
        }
    }
    protected void Timer1_Tick(object sender, EventArgs e)
    {
        TimeSpan time1 = new TimeSpan();
        time1 = (DateTime)Session["time"] - DateTime.Now;
        if (time1.Seconds <= 0)
        {
            Label1.Text = "TimeOut!";
        }
        else
        {
            Label1.Text = time1.Minutes.ToString() + ":" + time1.Seconds.ToString();
        }
    }
}