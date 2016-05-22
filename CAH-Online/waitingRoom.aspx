<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    int indexRoom;
    Room room = new Room();
    int totalSeconds = 0;
    int seconds = 0;
    int minutes = 0;
    string time = "";
    //bool ok = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        //FunctionsDB.OpenConnectionDB();

        int NumberUsers = FunctionsDB.ReadUsersInRoom(indexRoom);

        /*if (NumberUsers == 5)
        {
            Response.Redirect("~/game.aspx");
        }
        else */
        /*if (NumberUsers == 3)
        {
            Response.Redirect("~/game.aspx");
        }*/

        if (!Page.IsPostBack)
        {
            Game.NewGame(Master.resultUser);
            Session["time1"] = 3; //definisco tempo per il conteggio alla rovescia. Il tempo stabilito è di 20 sec
        }
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        Session["time1"] = Convert.ToInt16(Session["time1"]) - 1;
        if (Convert.ToInt16(Session["time1"]) <= 0)
        {
            int NumberUsers = FunctionsDB.ReadUsersInRoom(indexRoom);

            /*if (NumberUsers == 5)
            {
                Response.Redirect("~/game.aspx");
            }
            else */if (NumberUsers == 3)
            {
                FunctionsDB.UpdateMatchesPlayed(Master.resultUser);
                Response.Redirect("~/game.aspx");
            }
            else if (NumberUsers < 3)
            {
                string script = "alert(\"Non ci sono abbastanza giocatori in attesa di iniziare una partita!\");";
                ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                
                room.DeleteCardsUser(Master.resultUser);

                if (!room.CheckDeleteCardsBlcak(indexRoom))
                {
                    room.DeleteCardBlack(indexRoom);
                }
                if (!room.CheckDeleteKeyRoom(indexRoom))
                {
                    room.DeleteRoomInListUsers(indexRoom);
                }
                if (!Game.CheckDeleteRoom(indexRoom))
                {
                    Game.DeleteRoom(indexRoom);
                }
                if (FunctionsDB.CheckRoom(indexRoom))
                {
                    FunctionsDB.DeleteRoomDB(indexRoom);
                }


                //ok = true;
                Response.Redirect("~/index.aspx");
            }
            
            /*if(ok == true)
            {
                Response.Redirect("~/index.aspx");
            }*/
        }
        else
        {
            totalSeconds = Convert.ToInt16(Session["time1"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:Timer ID="Timer1" runat="server" Interval="10000" OnTick="Timer1_Tick"></asp:Timer>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row">
                <div class="col-md-4">
                    <p style="color: #FFFFFF">Attendere, altri giocatori …</p>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

