<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">
        
    protected void Page_Load(object sender, EventArgs e)
    {
        Room room = new Room();
        if (room.ExistUserInRoom(Master.resultUser))
        {
            int indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
            FunctionsDB.UpdateUserExit(Master.resultUser);

            if (room.CheckDeleteCardsUser(Master.resultUser))
            {
                room.DeleteCardsUser(Master.resultUser);
            }
            if (room.CheckDeleteUser(indexRoom, Master.resultUser))
            {
                room.DeleteUser(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckUserInGame(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteUserInGame(Master.resultUser);
            }
            if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckDeleteCardsWhite(indexRoom, Master.resultUser))
            {
                FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
            }
            if (FunctionsDB.CheckDeleteCardsBlack(indexRoom))
            {
                FunctionsDB.DeleteCardsBlack(indexRoom);
            }
        }
        lblEmailUse.Text = Session["userEmail"].ToString();
    }

    protected void btnSalva_Click(object sender, EventArgs e)
    {
        String pwd = txtPassword.Text;
        String user = txtUsername.Text;

        if (FunctionsDB.CeckUsername(user))//Controllo che il username scelto non sia già utilizzato da altri utenti
        {
            lblUser.Text = "This username has been used by someone else.";
            //if (txtUsername.Text == "")
            //{
            //    lblUser.Text = "X";
            //}
        }
        else //Se il nome utente non è già stato utilizzato e la texPwd è vuota eseguo la funzione ChangeUsername
        {
            if (txtUsername.Text == "")
            {
                lblUserError.Text = "X";
            }
            else
            {
                FunctionsDB.ChangeUsername(user);
                Response.Redirect("~/index.aspx");
            }
        }

        if (txtUsername.Text == "" & txtPassword.Text != "")//Se la textUsername è vuota eseguo il ChangePwd
        {
            FunctionsDB.ChangePwd(pwd);
            Response.Redirect("~/index.aspx");
        }

        if (FunctionsDB.CeckUsername(user) == false & txtUsername.Text != "" & txtPassword.Text != "")//Se il nome utente non è già stato utilizzato e la textUsername non è vuota eseguo la funzione ChangeUsername e ChangePwd 
        {
            FunctionsDB.ChangeUsername(user);
            FunctionsDB.ChangePwd(pwd);
            Response.Redirect("~/index.aspx");
        }
        else
        {
            lblUserError.Text = "X";
            lblPwd.Text = "X";
        }
    }

    protected void btnAnnulla_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/index.aspx");
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="css/gears.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <div class="row">
                    <div class="col-md-4">
                        <div class="position-right">
                            <figure>
                                <img src="img/gtk-about.png" class="gr1 gr1-right" />
                                <img src="img/gtk-about.png" class="gr2 gr2-right" />
                                <img src="img/gtk-about.png" class="gr3 gr3-right" />
                            </figure>
                        </div>
                    </div>
                    <div class="card-panel-x panel-x">
                        <h2 class="h1-text">Settings</h2>
                        <%--<h5 class="h5-text">Qui puoi modificare il tuo username e la password.</h5>--%>
                        <h5 class="h5-text">Here you can edit your username and password.</h5>
                        <div style="margin-top: 75px">
                            <asp:Label ID="lblEmail" runat="server" Text="E-mail address:" CssClass="profile-x email"></asp:Label>
                            <asp:Label ID="lblEmailUse" class="label-form" runat="server" ForeColor="White"></asp:Label>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:Label ID="lblUsername" runat="server" Text="Username:" CssClass="profile-x username"></asp:Label>
                            <asp:TextBox ID="txtUsername" placeholder="Username" runat="server" Width="400px" ForeColor="White" />
                            <asp:Label ID="lblUserError" runat="server" class="info-error" ForeColor="#FF3300"></asp:Label>
                        </div> 
                        <asp:Label ID="lblUser" runat="server" class="info-error" ForeColor="#FF3300"></asp:Label>
                        <div style="margin-top: 25px">
                            <asp:Label ID="lblPassword" runat="server" Text="Password:" CssClass="profile-x password"></asp:Label>
                            <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" Width="400px" ForeColor="White" />
                            <asp:Label ID="lblPwd" runat="server" class="info-error" ForeColor="#FF3300"></asp:Label>
                        </div>
                         <div style="margin-top: 25px">
                            <asp:LinkButton ID="btnAnnulla" runat="server" CssClass="btn waves-effect waves-light btn-x btn-cancel" OnClick="btnAnnulla_Click">Cancel
                                <i class="material-icons right">send</i>
                            </asp:LinkButton>
                        </div>
                        <div style="margin-top: 25px">
                            <asp:LinkButton ID="btnSalva" runat="server" CssClass="btn waves-effect waves-light btn-x btn-save" OnClick="btnSalva_Click">Save
                                <i class="material-icons right">send</i>
                            </asp:LinkButton>
                        </div>
                    </div>
                    </div>               
                </div>
            </div>
        </div>
</asp:Content>


