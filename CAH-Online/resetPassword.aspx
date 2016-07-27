<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String pwd, email;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (FunctionsDB.ExistCookies())
        {
            Room room = new Room();
            if (room.ExistUserInRoom(Master.resultUser))
            {
                int indexRoom = room.ReturnKeyRoomUser(Master.resultUser);

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
            FunctionsDB.DeleteCookies(Master.resultUser);
            Response.Redirect("~/resetPassword.aspx");
        }
    }

    protected void btnReset_Click1(object sender, EventArgs e)
    {
        email = txtEmail.Text;
        pwd = txtPassword.Text;

        if (FunctionsDB.ResetPwd(email, pwd))
        {
            Response.Redirect("~/login.aspx");
        }
        else
        {
            lblMsg.Text = "Invalid credentials. Please try again.";
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-8">
                <div class="row">
                    <div class="col-md-16">
                        <div class="card-panel-x">
                            <h2 class="h1-text">Change password</h2>
                            <%--<h5 class="h5-text">Se ti sei dimenticato la password, qui puoi cambiarla.</h5>--%>
                            <h5 class="h5-text">If you forget your password, you can change it here.</h5>
                            <div style="margin-top: 75px">
                                <asp:Label ID="lblEmail" runat="server" Text="E-mail address:" CssClass="profile-x email"></asp:Label>
                                <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" Width="400px" ForeColor="White" />
                                <%--<asp:RegularExpressionValidator ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" />--%>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="X" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtEmail" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                            </div>
                            <div style="margin-top: 25px">
                                <asp:Label ID="lblPassword" runat="server" Text="Password:" CssClass="profile-x password"></asp:Label>
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" Width="400px" ForeColor="White" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtPassword" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                            </div>
                            <div style="margin-top: 25px">
                                <asp:LinkButton ID="btnReset" runat="server" CssClass="btn waves-effect waves-light btn-x" OnClick="btnReset_Click1">Change<i class="material-icons right">send</i></asp:LinkButton>
                                <asp:Label ID="lblMsg" ForeColor="#FF3300" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
        
                